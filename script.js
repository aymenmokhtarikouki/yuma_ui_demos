const lanes = document.querySelectorAll('.lane[data-status]');

lanes.forEach((lane) => {
  const total = lane.querySelectorAll('.order-card').length;
  const badge = lane.querySelector('.count');
  if (badge) badge.textContent = String(total);
});
