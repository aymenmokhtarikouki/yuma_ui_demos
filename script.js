const counts = {
  new: document.querySelectorAll('[data-status="new"] .order-card').length,
  confirmed: document.querySelectorAll('[data-status="confirmed"] .order-card').length,
  done: document.querySelectorAll('[data-status="done"] .order-card').length,
};

Object.entries(counts).forEach(([status, total]) => {
  const badge = document.querySelector(`[data-status="${status}"] .count`);
  if (badge) badge.textContent = String(total);
});
