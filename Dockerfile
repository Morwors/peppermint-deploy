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

# --- Color Rebrand: green → indigo/violet to match TicketSeat ---
# Login button & primary actions
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
      -e 's/bg-green-700\/10/bg-indigo-700\/10/g' \
      -e 's/ring-green-500\/20/ring-indigo-500\/20/g' \
      -e 's/ring-green-600\/20/ring-indigo-600\/20/g' \
      -e 's/fill-green-500/fill-indigo-500/g' \
      -e 's/text-indigo-600 hover:text-indigo-500/text-indigo-600 hover:text-indigo-500/g' \
      {} \; 2>/dev/null; true

# --- Hide "Send Feedback" and "Version" badge via CSS ---
# Also inject TicketSeat theme overrides into the compiled CSS
RUN CSSFILE=$(find /apps/client -name "*.css" -path "*/_next/static/css/*" | head -1) && \
    if [ -n "$CSSFILE" ]; then \
    cat >> "$CSSFILE" <<'THEMECSS'

/* === TicketSeat Theme Overrides === */
:root {
  --primary: 234 89% 74% !important;
  --primary-foreground: 0 0% 100% !important;
  --ring: 234 89% 74% !important;
  --sidebar-background: 229 84% 5% !important;
  --sidebar-foreground: 226 100% 94% !important;
  --sidebar-primary: 234 89% 74% !important;
  --sidebar-primary-foreground: 0 0% 100% !important;
  --sidebar-accent: 229 50% 12% !important;
  --sidebar-accent-foreground: 226 100% 94% !important;
  --sidebar-border: 229 40% 15% !important;
  --sidebar-ring: 234 89% 74% !important;
}
.dark {
  --primary: 234 89% 74% !important;
  --primary-foreground: 0 0% 100% !important;
  --ring: 234 89% 74% !important;
  --sidebar-background: 229 84% 5% !important;
  --sidebar-foreground: 226 100% 94% !important;
  --sidebar-primary: 234 89% 74% !important;
  --sidebar-primary-foreground: 0 0% 100% !important;
  --sidebar-accent: 229 50% 10% !important;
  --sidebar-accent-foreground: 226 100% 94% !important;
  --sidebar-border: 229 40% 12% !important;
}
/* Hide version badge */
a[href*="ticketseat.io"] > span[class*="bg-indigo-700"],
a[href*="ticketseat.io"] > span[class*="bg-green-700"] {
  display: none !important;
}
/* Hide Send Feedback button in header */
.flex.w-full.justify-end a[href*="ticketseat.io"][target="_blank"] {
  display: none !important;
}
/* Login page modernization */
.min-h-screen.bg-background.flex.flex-col.justify-center {
  background: linear-gradient(135deg, #0f0a2e 0%, #1e1b4b 50%, #312e81 100%) !important;
}
.min-h-screen.bg-background.flex.flex-col.justify-center .sm\:rounded-lg {
  border-radius: 16px !important;
  border: 1px solid rgba(255,255,255,0.08) !important;
  box-shadow: 0 25px 50px -12px rgba(0,0,0,0.5) !important;
}
.min-h-screen.bg-background.flex.flex-col.justify-center h2 {
  color: #e0e7ff !important;
}
.min-h-screen.bg-background.flex.flex-col.justify-center label {
  color: #c7d2fe !important;
}
.min-h-screen.bg-background.flex.flex-col.justify-center .bg-background {
  background: rgba(15, 10, 46, 0.7) !important;
  backdrop-filter: blur(20px) !important;
  -webkit-backdrop-filter: blur(20px) !important;
}
.min-h-screen.bg-background.flex.flex-col.justify-center input {
  background: rgba(255,255,255,0.06) !important;
  border-color: rgba(255,255,255,0.12) !important;
  color: #e0e7ff !important;
}
.min-h-screen.bg-background.flex.flex-col.justify-center input::placeholder {
  color: rgba(199,210,254,0.4) !important;
}
.min-h-screen.bg-background.flex.flex-col.justify-center input:focus {
  border-color: #818cf8 !important;
  box-shadow: 0 0 0 2px rgba(129,140,248,0.3) !important;
}
.min-h-screen.bg-background.flex.flex-col.justify-center button[type="submit"],
.min-h-screen.bg-background.flex.flex-col.justify-center .bg-indigo-600 {
  background: #6366f1 !important;
  border: none !important;
  border-radius: 10px !important;
  font-weight: 500 !important;
  letter-spacing: 0.01em !important;
  transition: all 0.15s ease !important;
}
.min-h-screen.bg-background.flex.flex-col.justify-center button[type="submit"]:hover,
.min-h-screen.bg-background.flex.flex-col.justify-center .bg-indigo-600:hover {
  background: #4f46e5 !important;
  transform: translateY(-1px) !important;
  box-shadow: 0 4px 12px rgba(99,102,241,0.4) !important;
}
.min-h-screen.bg-background.flex.flex-col.justify-center .text-indigo-600 {
  color: #a5b4fc !important;
}
.min-h-screen.bg-background.flex.flex-col.justify-center .text-indigo-600:hover {
  color: #c7d2fe !important;
}
/* Footer on login — make subtle */
.min-h-screen.bg-background.flex.flex-col.justify-center .mt-8.text-center {
  display: none !important;
}
/* Dashboard stat cards — navy */
.bg-gray-900.text-white.rounded-lg,
[class*="bg-gray-900"][class*="rounded"] {
  background: linear-gradient(135deg, #1e1b4b 0%, #312e81 100%) !important;
}
/* Status badge "Open" — indigo tint */
span:has(> .fill-green-500) .fill-green-500,
.fill-green-500 {
  fill: #6366f1 !important;
}
/* Sidebar version text */
.text-xs.text-muted-foreground {
  opacity: 0.5;
}
THEMECSS
    echo "CSS injected into $CSSFILE"; \
    fi

EXPOSE 3000 5003
CMD ["pm2-runtime", "ecosystem.config.js"]
