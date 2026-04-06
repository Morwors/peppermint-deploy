FROM pepperlabs/peppermint:latest

# --- Bug Fix: ticket creation email never fires ---
# Original condition: !email && !validateEmail(email) — always false
# Fixed:             email && validateEmail(email) — sends when email is valid
RUN find / -path "*/controllers/ticket.js" -exec \
    sed -i 's/!email && !validateEmail(email)/email \&\& validateEmail(email)/g' {} \; 2>/dev/null; true

# --- Rebrand: Peppermint → TicketSeat Support ---
# Patch both pre-rendered HTML (SSG) and JS chunks
RUN find /apps/client \( -name "*.html" -o -name "*.js" \) -exec \
    sed -i \
      -e 's/Welcome to Peppermint/TicketSeat Support/g' \
      -e 's/>Peppermint</>TicketSeat Support</g' \
      -e 's/"Peppermint"/"TicketSeat Support"/g' \
      -e "s/'Peppermint'/'TicketSeat Support'/g" \
      -e 's/Peppermint Labs/TicketSeat/g' \
      -e 's|https://docs\.peppermint\.sh[^"]*|https://ticketseat.io|g' \
      -e 's|https://github\.com/Peppermint-Lab/peppermint[^"]*|https://ticketseat.io|g' \
      -e 's/bg-green-600/bg-gray-900/g' \
      -e 's/hover:bg-green-700/hover:bg-gray-800/g' \
      -e 's/ring-green-500/ring-gray-500/g' \
      -e 's/border-green-500/border-gray-900/g' \
      -e 's/focus:ring-green-500 focus:border-green-500/focus:ring-gray-900 focus:border-gray-900/g' \
      -e 's/>Documentation</>ticketseat.io</g' \
      {} \; 2>/dev/null; true

EXPOSE 3000 5003
CMD ["pm2-runtime", "ecosystem.config.js"]
