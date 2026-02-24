const lanes = {
  new: document.querySelector('.lane[data-status="new"] .cards'),
  inprogress: document.querySelector('.lane[data-status="inprogress"] .cards'),
  done: document.querySelector('.lane[data-status="done"] .cards'),
};

const sheet = document.getElementById('decline-sheet');
let pendingDeclineCard = null;

const vibrate = (pattern = 15) => navigator.vibrate?.(pattern);

const updateCounts = () => {
  Object.entries(lanes).forEach(([key, container]) => {
    const total = container?.querySelectorAll('.order-card').length ?? 0;
    const badge = document.querySelector(`.lane[data-status="${key}"] .count`);
    if (badge) badge.textContent = String(total);
  });

  document.getElementById('sum-new').textContent = lanes.new?.querySelectorAll('.order-card').length ?? 0;
  document.getElementById('sum-progress').textContent = lanes.inprogress?.querySelectorAll('.order-card').length ?? 0;
  document.getElementById('sum-done').textContent = lanes.done?.querySelectorAll('.order-card').length ?? 0;
};

const smoothMove = (card, targetContainer, statusText = 'Completed') => {
  card.style.transition = 'opacity .22s ease, transform .22s ease, max-height .22s ease, margin .22s ease';
  card.style.maxHeight = `${card.offsetHeight}px`;
  requestAnimationFrame(() => {
    card.style.opacity = '0';
    card.style.transform = 'translateY(-5px)';
    card.style.maxHeight = '0px';
    card.style.marginBottom = '0px';
  });

  setTimeout(() => {
    const status = card.querySelector('.status-line');
    if (status) {
      status.className = 'status-line';
      status.innerHTML = statusText === 'Awaiting confirmation' ? '<span class="dot"></span>Awaiting confirmation' : statusText;
    }
    card.classList.remove('priority-high', 'priority-mid');
    if (targetContainer === lanes.done) card.classList.add('priority-low', 'compact');

    card.style.opacity = '';
    card.style.transform = '';
    card.style.maxHeight = '';
    card.style.marginBottom = '';
    targetContainer.prepend(card);
    card.querySelector('.card-body')?.style.setProperty('transform', 'translateX(0)');
    updateCounts();
  }, 230);
};

const handleConfirm = (card, button) => {
  button.classList.add('loading');
  setTimeout(() => {
    button.classList.remove('loading');
    button.classList.add('success');
    button.textContent = 'Done';
    vibrate([10, 40, 10]);

    const inNew = card.closest('.lane')?.dataset.status === 'new';
    if (inNew) {
      const status = card.querySelector('.status-line');
      if (status) {
        status.className = 'status-line';
        status.textContent = 'Scheduled delivery';
      }
      smoothMove(card, lanes.inprogress, 'Scheduled delivery');
      const footerBtn = card.querySelector('.confirm-btn');
      if (footerBtn) {
        footerBtn.className = 'light-btn action-complete';
        footerBtn.textContent = 'Confirm delivery';
      }
      const declineBtn = card.querySelector('.decline-btn');
      if (declineBtn) declineBtn.remove();
    } else {
      smoothMove(card, lanes.done, 'Completed');
    }
  }, 300);
};

const declineCard = (card) => {
  vibrate(20);
  card.style.transition = 'opacity .2s ease, transform .2s ease';
  card.style.opacity = '0';
  card.style.transform = 'scale(.98)';
  setTimeout(() => {
    card.remove();
    updateCounts();
  }, 220);
};

document.addEventListener('click', (event) => {
  const card = event.target.closest('.order-card');
  if (!card) return;

  if (event.target.closest('.action-confirm') || event.target.closest('.action-complete')) {
    const btn = event.target.closest('button');
    if (btn) handleConfirm(card, btn);
  }

  if (event.target.closest('.action-decline')) {
    pendingDeclineCard = card;
    sheet.showModal();
  }
});

sheet?.addEventListener('close', () => {
  if (sheet.returnValue === 'confirm' && pendingDeclineCard) declineCard(pendingDeclineCard);
  pendingDeclineCard = null;
});

const enableSwipe = (card) => {
  const body = card.querySelector('.card-body');
  if (!body) return;

  let startX = 0;
  let currentX = 0;
  let dragging = false;
  let vibrated = false;
  const threshold = 110;

  card.addEventListener('pointerdown', (e) => {
    startX = e.clientX;
    dragging = true;
    vibrated = false;
    body.style.transition = 'none';
  });

  card.addEventListener('pointermove', (e) => {
    if (!dragging) return;
    currentX = Math.max(-140, Math.min(140, e.clientX - startX));
    body.style.transform = `translateX(${currentX}px)`;

    if (!vibrated && Math.abs(currentX) > threshold) {
      vibrate(12);
      vibrated = true;
    }
  });

  const endSwipe = () => {
    if (!dragging) return;
    dragging = false;
    body.style.transition = 'transform .2s ease';

    if (currentX > threshold) {
      body.style.transform = 'translateX(140px)';
      setTimeout(() => {
        const btn = card.querySelector('.action-confirm, .action-complete');
        if (btn) handleConfirm(card, btn);
        body.style.transform = 'translateX(0)';
      }, 140);
    } else if (currentX < -threshold) {
      body.style.transform = 'translateX(-140px)';
      setTimeout(() => {
        const canDecline = card.querySelector('.action-decline');
        if (canDecline) {
          pendingDeclineCard = card;
          sheet.showModal();
        }
        body.style.transform = 'translateX(0)';
      }, 140);
    } else {
      body.style.transform = 'translateX(0)';
    }
    currentX = 0;
  };

  card.addEventListener('pointerup', endSwipe);
  card.addEventListener('pointercancel', endSwipe);
};

const skeletonize = () => {
  document.querySelectorAll('.order-card').forEach((card) => card.classList.add('skeleton'));
  setTimeout(() => {
    document.querySelectorAll('.order-card').forEach((card) => card.classList.remove('skeleton'));
  }, 650);
};

document.querySelectorAll('.swipe-card').forEach(enableSwipe);
skeletonize();
updateCounts();
