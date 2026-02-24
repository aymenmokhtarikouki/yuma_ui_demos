const lanes = {
  new: document.querySelector('.lane[data-status="new"] .cards'),
  inprogress: document.querySelector('.lane[data-status="inprogress"] .cards'),
  done: document.querySelector('.lane[data-status="done"] .cards'),
};

const appShell = document.querySelector('.app-shell');
const ordersView = document.getElementById('orders-view');
const prepView = document.getElementById('prep-view');
const prepList = document.getElementById('prep-list');
const timeChips = document.querySelectorAll('.time-chip');
const statusChips = document.querySelectorAll('.status-chip');


const sheet = document.getElementById('decline-sheet');
let pendingDeclineCard = null;
let currentSlot = 'all';
let currentStatusFilter = 'all';
let currentMode = 'orders';

const vibrate = (pattern = 15) => navigator.vibrate?.(pattern);

const slotMatch = (card, slot = currentSlot) => slot === 'all' || card.dataset.slot === slot;

const getVisibleCards = (container) => [...(container?.querySelectorAll('.order-card') ?? [])].filter((card) => card.style.display !== 'none');

const updateCounts = () => {
  Object.entries(lanes).forEach(([key, container]) => {
    const total = getVisibleCards(container).length;
    const badge = document.querySelector(`.lane[data-status="${key}"] .count`);
    if (badge) badge.textContent = String(total);
  });

  const sumNew = document.getElementById('sum-new');
  const sumProgress = document.getElementById('sum-progress');
  const sumDone = document.getElementById('sum-done');
  if (sumNew) sumNew.textContent = getVisibleCards(lanes.new).length;
  if (sumProgress) sumProgress.textContent = getVisibleCards(lanes.inprogress).length;
  if (sumDone) sumDone.textContent = getVisibleCards(lanes.done).length;
};

const applyFilters = () => {
  document.querySelectorAll('.lane').forEach((lane) => {
    const laneStatus = lane.dataset.status;
    const laneAllowed = currentStatusFilter === 'all' || currentStatusFilter === laneStatus;

    let visibleInLane = 0;
    lane.querySelectorAll('.order-card').forEach((card) => {
      const visible = laneAllowed && slotMatch(card);
      card.style.display = visible ? '' : 'none';
      if (visible) visibleInLane += 1;
    });

    lane.style.display = laneAllowed && visibleInLane > 0 ? '' : 'none';
  });

  updateCounts();
  if (currentMode === 'prep') renderPrepView();
};

const renderPrepView = () => {
  const prepMap = new Map();
  const activeCards = [
    ...getVisibleCards(lanes.new),
    ...getVisibleCards(lanes.inprogress),
  ];

  activeCards.forEach((card) => {
    const title = card.querySelector('.title')?.textContent?.trim() || 'Unknown meal';
    const portions = Number(card.dataset.portions || '1');
    prepMap.set(title, (prepMap.get(title) || 0) + portions);
  });

  if (!prepMap.size) {
    prepList.innerHTML = `<p class="prep-empty">No prep items for this time slot.</p>`;
    return;
  }

  prepList.innerHTML = [...prepMap.entries()]
    .map(
      ([meal, portions]) => `
        <article class="prep-card">
          <div class="prep-top">
            <p class="prep-title">${meal}</p>
            <p class="prep-count">${portions} portions</p>
          </div>
          <p class="prep-meta">Time slot: ${currentSlot === 'all' ? 'All day' : currentSlot.replace('-', '–')}</p>
        </article>
      `,
    )
    .join('');
};

const setMode = (mode) => {
  currentMode = mode;
  appShell?.setAttribute('data-mode', mode);
  const showOrders = mode === 'orders';
  ordersView?.classList.toggle('hidden', !showOrders);
  prepView?.classList.toggle('hidden', showOrders);

  if (!showOrders) renderPrepView();
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
    applyFilters();
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
    applyFilters();
  }, 220);
};

document.addEventListener('click', (event) => {
  if (event.target.closest('#prep-mode-btn')) {
    setMode('prep');
    return;
  }

  const timeChip = event.target.closest('.time-chip');
  if (timeChip) {
    currentSlot = timeChip.dataset.slot || 'all';
    timeChips.forEach((chip) => {
      const active = chip === timeChip;
      chip.classList.toggle('active', active);
      chip.setAttribute('aria-selected', active ? 'true' : 'false');
    });
    applyFilters();
    return;
  }

  const statusChip = event.target.closest('.status-chip');
  if (statusChip) {
    currentStatusFilter = statusChip.dataset.statusFilter || 'all';
    statusChips.forEach((chip) => {
      const active = chip === statusChip;
      chip.classList.toggle('active', active);
      chip.setAttribute('aria-selected', active ? 'true' : 'false');
    });
    applyFilters();
    return;
  }

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
    if (!dragging || card.style.display === 'none') return;
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
applyFilters();
setMode('orders');
