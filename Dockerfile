FROM pepperlabs/peppermint:latest

# --- Bug Fix: ticket creation email never fires ---
RUN find / -path "*/controllers/ticket.js" -exec \
    sed -i 's/!email && !validateEmail(email)/email \&\& validateEmail(email)/g' {} \; 2>/dev/null; true

# --- Text Rebrand: Peppermint → TicketSeat Support ---
RUN find /apps/client \( -name "*.html" -o -name "*.js" \) -exec \
    sed -i \
      -e 's/Welcome to Peppermint/TicketSeat Support/g' \
      -e 's/>Peppermint</>TicketSeat Support</g' \
      -e 's/"Peppermint"/"TicketSeat Support"/g' \
      -e "s/'Peppermint'/'TicketSeat Support'/g" \
      -e 's/Peppermint Labs/TicketSeat/g' \
      -e 's/Peppermint Light/Light/g' \
      -e 's/Peppermint Dark/Dark/g' \
      -e 's/TicketSeat Support Light/Light/g' \
      -e 's/TicketSeat Support Dark/Dark/g' \
      -e 's|https://docs\.peppermint\.sh[^"]*|https://ticketseat.io|g' \
      -e 's|https://github\.com/Peppermint-Lab/peppermint[^"]*|https://ticketseat.io|g' \
      -e 's/>Documentation</>ticketseat.io</g' \
      {} \; 2>/dev/null; true

# --- Color Rebrand: green → indigo throughout ---
RUN find /apps/client \( -name "*.html" -o -name "*.js" \) -exec \
    sed -i \
      -e 's/bg-green-600/bg-indigo-600/g' \
      -e 's/hover:bg-green-700/hover:bg-indigo-700/g' \
      -e 's/ring-green-500/ring-indigo-500/g' \
      -e 's/border-green-500/border-indigo-500/g' \
      -e 's/focus:ring-green-500/focus:ring-indigo-500/g' \
      -e 's/focus:border-green-500/focus:border-indigo-500/g' \
      -e 's/text-green-600/text-indigo-600/g' \
      -e 's/text-green-500/text-indigo-500/g' \
      -e 's/text-green-800/text-indigo-800/g' \
      -e 's/text-green-400/text-indigo-400/g' \
      -e 's/bg-green-100/bg-indigo-100/g' \
      -e 's/bg-green-50/bg-indigo-50/g' \
      -e 's/bg-green-700/bg-indigo-700/g' \
      -e 's/ring-green-600\/20/ring-indigo-600\/20/g' \
      -e 's/fill-green-500/fill-indigo-500/g' \
      {} \; 2>/dev/null; true

# --- Inject TicketSeat theme CSS overrides ---
COPY ticketseat-theme.css /tmp/ticketseat-theme.css
RUN CSSFILE=$(find /apps/client -name "*.css" -path "*/.next/static/css/*" | head -1) && \
    if [ -n "$CSSFILE" ]; then \
      cat /tmp/ticketseat-theme.css >> "$CSSFILE" && \
      echo "CSS injected into $CSSFILE"; \
    fi && \
    rm -f /tmp/ticketseat-theme.css

EXPOSE 3000 5003
CMD ["pm2-runtime", "ecosystem.config.js"]
