const timeSlots = ["All day", "08–10", "10–12", "12–14", "14–16", "16–18", "18–20", "20–22"];

const orderModel = [
  { id: "297980", title: "Cheesecake Box", customer: "Aymen Mokhtari", type: "Pickup", status: "new", time: "12:00", action: "Confirm", icon: "meal" },
  { id: "297982", title: "Chocolate Snacks Bundle", customer: "Lina Barakat", type: "Delivery", status: "new", time: "12:06", action: "Confirm", icon: "delivery" },
  { id: "297989", title: "Protein Lunch Bowl", customer: "Rayan Salem", type: "Pickup", status: "new", time: "12:11", action: "Confirm", icon: "meal" },
  { id: "297991", title: "Vegan Wrap Pack", customer: "Nada Khoury", type: "Delivery", status: "new", time: "12:14", action: "Confirm", icon: "delivery" },
  { id: "297981", title: "Weekly Meal Plan", customer: "Sami Obaid", type: "Scheduled delivery", status: "inprogress", phase: "driver_arriving", time: "13:30", action: "Confirm delivery", icon: "delivery" },
  { id: "297977", title: "Daily Hot Meal", customer: "Nour Haddad", type: "Scheduled pickup", status: "inprogress", phase: "ready_pickup", time: "12:45", action: "Confirm pickup", icon: "pickup" },
  { id: "297973", title: "Family Dinner Set", customer: "Tareq Hamdan", type: "Scheduled delivery", status: "inprogress", phase: "awaiting_handoff", time: "14:05", action: "Confirm delivery", icon: "delivery" },
  { id: "297969", title: "Office Meal Tray", customer: "Mira Issa", type: "Scheduled pickup", status: "inprogress", phase: "preparing", time: "14:20", action: "Confirm pickup", icon: "pickup" },
  { id: "297965", title: "Falafel Wrap Combo", customer: "Youssef Naim", type: "Pickup", status: "done", time: "11:14", action: null, icon: "meal" },
  { id: "297970", title: "Fruit Bowl Pack", customer: "Nour Haddad", type: "Delivery", status: "done", time: "11:40", action: null, icon: "delivery" },
  { id: "297954", title: "Chicken Rice Box", customer: "Salma Jaber", type: "Pickup", status: "done", time: "10:52", action: null, icon: "meal" },
  { id: "297948", title: "Keto Snack Kit", customer: "Hadi Nasser", type: "Delivery", status: "done", time: "10:35", action: null, icon: "delivery" }
];

const state = {
  selectedSlot: "All day",
  viewMode: "orders",
  reducedMotion: window.matchMedia("(prefers-reduced-motion: reduce)").matches,
  pendingDeclineId: null,
  sectionCounts: {},
  kitchenOpen: true,
  collapsedSections: {
    new: false,
    inprogress: false,
    done: false
  }
};

const sections = [["new", "New"], ["inprogress", "In progress"], ["done", "Completed"]];

const slotRoot = document.getElementById("timeSlots");
const ordersRoot = document.getElementById("ordersRoot");
const ordersPage = document.getElementById("ordersPage");
const focusToggle = document.getElementById("focusToggle");
const toast = document.getElementById("toast");
const declineSheet = document.getElementById("declineSheet");
const sheetBackdrop = document.getElementById("sheetBackdrop");
const sheetCancel = document.querySelector("[data-sheet-cancel]");
const sheetConfirm = document.querySelector("[data-sheet-confirm]");
const kitchenToggle = document.getElementById("kitchenToggle");
const kitchenLabel = document.getElementById("kitchenLabel");
const kitchenBanner = document.getElementById("kitchenBanner");
const salesPage = document.getElementById("salesPage");
const mealsPage = document.getElementById("mealsPage");
const profilePage = document.getElementById("profilePage");
const salesFilters = document.getElementById("salesFilters");
const salesList = document.getElementById("salesList");
const salesAddBtn = document.getElementById("salesAddBtn");
const bottomNav = document.getElementById("bottomNav");
const focusPrepPage = document.getElementById("focusPrepPage");
const focusBack = document.getElementById("focusBack");
const weekdayStrip = document.getElementById("weekdayStrip");
const prepSummary = document.getElementById("prepSummary");
const prepList = document.getElementById("prepList");

// Focus Mode Prep Page — short weekday abbreviations (Req: short format Mo/Tu/We/Th/Fr/Sa/Su).
const weekdayLabels = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];

// Focus Mode Prep Page — aggregated prep data model by weekday (Req. Data Model).
const prepByDay = {
  0: [
    { dish: "Biryani", prepared: 12, total: 35 },
    { dish: "Roti", prepared: 8, total: 20 },
    { dish: "Chicken Bowl", prepared: 10, total: 18 },
    { dish: "Paneer Curry", prepared: 0, total: 16 },
    { dish: "Lentil Soup", prepared: 16, total: 16 }
  ],
  1: [
    { dish: "Biryani", prepared: 4, total: 26 },
    { dish: "Roti", prepared: 2, total: 22 },
    { dish: "Chicken Bowl", prepared: 7, total: 18 },
    { dish: "Mixed Salad", prepared: 18, total: 18 }
  ],
  2: [
    { dish: "Biryani", prepared: 0, total: 35 },
    { dish: "Roti", prepared: 0, total: 20 },
    { dish: "Chicken Bowl", prepared: 0, total: 18 },
    { dish: "Vegetable Rice", prepared: 0, total: 24 },
    { dish: "Lentil Soup", prepared: 0, total: 13 }
  ],
  3: [
    { dish: "Biryani", prepared: 20, total: 20 },
    { dish: "Roti", prepared: 12, total: 24 },
    { dish: "Chicken Bowl", prepared: 6, total: 20 }
  ],
  4: [
    { dish: "Family Meal", prepared: 0, total: 28 },
    { dish: "Paneer Curry", prepared: 0, total: 16 }
  ],
  5: [],
  6: []
};

const salesChannels = [
  { id: "ch_001", name: "Indian food", type: "Tiffin", status: "Active", ruleText: "Weekdays • Preorder 24h", kpiValue: 34, kpiLabel: "Orders today", icon: "🍱" },
  { id: "ch_002", name: "Office Tiffin", type: "Tiffin", status: "Paused", ruleText: "Every day • Preorder 24h", kpiValue: 0, kpiLabel: "Orders today", icon: "🍱" },
  { id: "ch_003", name: "Weekly Lunch Plan", type: "Weekly Plan", status: "Active", ruleText: "5 meals/week • Mon–Fri", kpiValue: 52, kpiLabel: "Subscribers", icon: "📅" },
  { id: "ch_004", name: "Family Meal Plan", type: "Weekly Plan", status: "Draft", ruleText: "7 meals/week • Mon–Sun", kpiValue: 12, kpiLabel: "Subscribers", icon: "📅" },
  { id: "ch_005", name: "Yuma Shop", type: "Shop", status: "Active", ruleText: "Order anytime • 48 items", kpiValue: 18, kpiLabel: "Orders today", icon: "🛍️" },
  { id: "ch_006", name: "Healthy Snacks Shop", type: "Shop", status: "Active", ruleText: "Order anytime • 31 items", kpiValue: 11, kpiLabel: "Orders today", icon: "🛍️" }
];

// Today selected by default for the weekday selector (Req).
state.selectedPrepDay = getTodayWeekdayIndex();
state.activeTab = "home";
state.salesFilter = "All";

renderSlots();
renderOrders();
bindFocusToggle();
bindDeclineSheet();
bindKitchenToggle();
bindFocusPrepNavigation();
renderWeekdays();
renderPrepSummary();
renderPrepList();
bindBottomNav();
renderSalesFilters();
renderSalesList();
setupDemoIncomingOrder();
setupAutoRefresh();

salesAddBtn?.addEventListener("click", () => showToast("Create channel (placeholder)"));

function renderSlots() {
  slotRoot.innerHTML = "";
  timeSlots.forEach((slot) => {
    const chip = document.createElement("button");
    chip.className = `slot-chip ${state.selectedSlot === slot ? "selected" : ""}`;
    chip.type = "button";
    chip.textContent = slot;
    chip.setAttribute("aria-pressed", state.selectedSlot === slot ? "true" : "false");
    chip.addEventListener("click", () => {
      state.selectedSlot = slot;
      renderSlots();
      chip.scrollIntoView({ behavior: state.reducedMotion ? "auto" : "smooth", inline: "center", block: "nearest" });
      vibrate(8);
    });
    slotRoot.appendChild(chip);
  });
}

function bindFocusToggle() {
  focusToggle.addEventListener("click", () => {
    openFocusPrepPage();
  });
}

function bindFocusPrepNavigation() {
  focusBack.addEventListener("click", closeFocusPrepPage);
}

// Focus Mode Prep Page entry/exit navigation from Orders focus button (Req. 1).
function openFocusPrepPage() {
  focusPrepPage.classList.add("open");
  focusToggle.classList.add("active");
  focusToggle.setAttribute("aria-pressed", "true");
  window.scrollTo({ top: 0, behavior: state.reducedMotion ? "auto" : "smooth" });
}

function closeFocusPrepPage() {
  focusPrepPage.classList.remove("open");
  focusToggle.classList.remove("active");
  focusToggle.setAttribute("aria-pressed", "false");
}

function getTodayWeekdayIndex() {
  const jsDay = new Date().getDay();
  return jsDay === 0 ? 6 : jsDay - 1;
}

function renderWeekdays() {
  // Weekday horizontal selector with state styling (Req. 3–7).
  weekdayStrip.innerHTML = "";
  const today = getTodayWeekdayIndex();

  weekdayLabels.forEach((label, index) => {
    const btn = document.createElement("button");
    btn.type = "button";
    const isPast = index < today;
    const isSelected = state.selectedPrepDay === index;
    btn.className = `day-pill ${isPast ? "past" : ""} ${isSelected ? "selected" : ""}`;
    // Meal count metric (Req): total meals/portions for the day (not prep lines/order count).
    const mealCount = getTotalMealCount(index);
    // 99+ cap for compact weekday pills (Req).
    const displayCount = mealCount > 99 ? "99+" : String(mealCount);
    // Stacked day + number layout (Req): day label on top, meal count under it.
    btn.innerHTML = `<span class="day-pill-day">${label}</span><span class="day-pill-count">${displayCount}</span>`;
    btn.setAttribute("aria-pressed", isSelected ? "true" : "false");
    btn.addEventListener("click", () => {
      state.selectedPrepDay = index;
      renderWeekdays();
      switchPrepDay();
    });
    weekdayStrip.appendChild(btn);
  });
}

function getTotalMealCount(dayIndex) {
  const items = prepByDay[dayIndex] || [];
  return items.reduce((sum, item) => sum + item.total, 0);
}

function switchPrepDay() {
  prepList.classList.add("switching");
  setTimeout(() => {
    renderPrepSummary();
    renderPrepList();
    prepList.classList.remove("switching");
    focusPrepPage.scrollTo({ top: 0, behavior: state.reducedMotion ? "auto" : "smooth" });
  }, state.reducedMotion ? 0 : 140);
}

function getPrepItems() {
  return prepByDay[state.selectedPrepDay] || [];
}

function prepSortWeight(item) {
  if (item.prepared <= 0) return 0;
  if (item.prepared >= item.total) return 2;
  return 1;
}

function renderPrepSummary() {
  // Daily prep summary reusable block: headline + metric chips (Req. redesigned summary area).
  const items = getPrepItems();
  const totalPortions = items.reduce((sum, item) => sum + item.total, 0);
  const preparedPortions = items.reduce((sum, item) => sum + Math.min(item.prepared, item.total), 0);
  const percent = totalPortions ? Math.round((preparedPortions / totalPortions) * 100) : 0;
  const todayIndex = getTodayWeekdayIndex();
  const dayLabel = state.selectedPrepDay === todayIndex ? "Today" : weekdayLabels[state.selectedPrepDay];

  prepSummary.innerHTML = `
    <h3>${dayLabel} — ${totalPortions} portions</h3>
    <div class="prep-metrics" aria-label="Summary metrics">
      <span class="prep-metric-chip">${items.length} dishes</span>
      <span class="prep-metric-chip done">${percent}% done</span>
    </div>
  `;
}

function renderPrepList() {
  // Prep aggregation list with completion sorting and empty state (Req. 8, 13, 16).
  const items = [...getPrepItems()].sort((a, b) => prepSortWeight(a) - prepSortWeight(b));
  prepList.innerHTML = "";

  if (!items.length) {
    prepList.innerHTML = `<div class="prep-empty">No meals scheduled for this day.</div>`;
    return;
  }

  items.forEach((item) => prepList.appendChild(createPrepCard(item)));
}

function createPrepCard(item) {
  // Prep tile content + progress + quick actions (+1/+5/Mark done) (Req. 9–12).
  const card = document.createElement("article");
  const done = item.prepared >= item.total;
  card.className = `prep-card ${done ? "completed" : ""}`;
  const progress = item.total ? Math.min(100, Math.round((item.prepared / item.total) * 100)) : 0;

  card.innerHTML = `
    <p class="prep-title">${item.dish}</p>
    <p class="prep-qty">${Math.min(item.prepared, item.total)} / ${item.total} <span>prepared${done ? " · Completed" : ""}</span></p>
    <div class="prep-progress"><div class="prep-progress-fill" style="width:${progress}%"></div></div>
    <div class="prep-actions">
      <button class="prep-btn secondary" type="button" data-add="1">+1</button>
      <button class="prep-btn secondary" type="button" data-add="5">+5</button>
      <button class="prep-btn primary" type="button" data-done="1">Mark done</button>
    </div>
  `;

  card.querySelector("[data-add='1']").addEventListener("click", () => updatePrep(item, 1));
  card.querySelector("[data-add='5']").addEventListener("click", () => updatePrep(item, 5));
  card.querySelector("[data-done='1']").addEventListener("click", () => markPrepDone(item));

  return card;
}

function updatePrep(item, delta) {
  item.prepared = Math.min(item.total, item.prepared + delta);
  renderPrepSummary();
  renderPrepList();
  vibrate(8);
}

function markPrepDone(item) {
  item.prepared = item.total;
  renderPrepSummary();
  renderPrepList();
  showToast(`${item.dish} completed`);
  vibrate(12);
}

function bindBottomNav() {
  bottomNav?.addEventListener("click", (event) => {
    const item = event.target.closest(".nav-item");
    if (!item) return;
    const tab = item.dataset.tab;
    setActiveTab(tab);
  });
}

function setActiveTab(tab) {
  state.activeTab = tab;
  const normalized = tab === "orders" ? "home" : tab;
  ordersPage.classList.toggle("app-hidden", normalized !== "home");
  salesPage.classList.toggle("app-hidden", normalized !== "sales");
  mealsPage.classList.toggle("app-hidden", normalized !== "meals");
  profilePage.classList.toggle("app-hidden", normalized !== "profile");

  document.querySelectorAll(".nav-item").forEach((el) => {
    const selected = el.dataset.tab === tab;
    el.classList.toggle("active", selected);
    el.setAttribute("aria-current", selected ? "page" : "false");
  });
}

function renderSalesFilters() {
  const filters = ["All", "Active", "Draft", "Paused"];
  salesFilters.innerHTML = "";
  filters.forEach((filter) => {
    const chip = document.createElement("button");
    chip.type = "button";
    chip.className = `sales-filter-chip ${state.salesFilter === filter ? "selected" : ""}`;
    chip.textContent = filter;
    chip.addEventListener("click", () => {
      state.salesFilter = filter;
      renderSalesFilters();
      renderSalesList();
    });
    salesFilters.appendChild(chip);
  });
}

function renderSalesList() {
  const list = state.salesFilter === "All" ? salesChannels : salesChannels.filter((c) => c.status === state.salesFilter);
  salesList.innerHTML = "";
  list.forEach((channel) => {
    const row = document.createElement("article");
    row.className = "sales-card";
    row.innerHTML = `
      <div class="sales-icon">${channel.icon}</div>
      <div class="sales-main">
        <div class="sales-title-row"><p class="sales-title">${channel.name}</p><span class="sales-pill">${channel.type}</span></div>
        <div class="sales-meta-row"><span class="sales-pill sales-status">${channel.status}</span><p class="sales-rule">${channel.ruleText}</p></div>
      </div>
      <div class="sales-kpi"><strong>${channel.kpiValue}</strong><small>${channel.kpiLabel}</small></div>
      <span class="sales-chevron">›</span>
    `;
    row.addEventListener("click", () => showToast(`${channel.name} details (placeholder)`));
    salesList.appendChild(row);
  });
}


function bindKitchenToggle() {
  kitchenToggle.checked = state.kitchenOpen;
  setKitchenState(state.kitchenOpen);
  kitchenToggle.addEventListener("change", () => {
    state.kitchenOpen = kitchenToggle.checked;
    setKitchenState(state.kitchenOpen);
    renderOrders();
  });
}

function setKitchenState(isOpen) {
  kitchenLabel.textContent = isOpen ? "Open" : "Closed";
  document.body.classList.toggle("kitchen-closed", !isOpen);
  kitchenBanner.classList.toggle("active", !isOpen);
}

function bindDeclineSheet() {
  sheetCancel.addEventListener("click", closeDeclineSheet);
  sheetBackdrop.addEventListener("click", closeDeclineSheet);
  sheetConfirm.addEventListener("click", () => {
    if (!state.pendingDeclineId) return;
    const idx = orderModel.findIndex((item) => item.id === state.pendingDeclineId);
    if (idx >= 0) {
      orderModel.splice(idx, 1);
      renderOrders();
      showToast("Order declined");
      vibrate(10);
    }
    closeDeclineSheet();
  });
}

function setViewMode(mode) {
  state.viewMode = mode;
  const isFocus = mode === "focus";
  focusToggle.classList.toggle("active", isFocus);
  focusToggle.setAttribute("aria-pressed", isFocus ? "true" : "false");
  document.querySelector(".app-shell").classList.toggle("focus-density", isFocus);
  document.body.classList.toggle("focus-mode", isFocus);


  vibrate(10);
  renderOrders();
}

function renderOrders() {
  ordersRoot.innerHTML = "";

  sections.forEach(([key, label]) => {
    if (state.viewMode === "focus" && key === "done") return;

    const list = orderModel
      .filter((order) => order.status === key)
      .sort((a, b) => minutesFromTime(a.time) - minutesFromTime(b.time));

    const section = document.createElement("section");
    const isCollapsed = Boolean(state.collapsedSections[key]);
    section.className = `section section-${key} ${isCollapsed ? "collapsed" : ""}`;

    const bump = state.sectionCounts[key] !== undefined && state.sectionCounts[key] !== list.length ? " count-bump" : "";
    state.sectionCounts[key] = list.length;

    section.innerHTML = `
      <header class="section-header">
        <button class="section-toggle" type="button" data-section="${key}" aria-expanded="${isCollapsed ? "false" : "true"}">
          <h2>${label}</h2>
          <span class="section-meta">
            <span class="count-badge${bump}">${list.length}</span>
            <span class="collapse-arrow" aria-hidden="true">⌄</span>
          </span>
        </button>
      </header>
      <div class="section-body">
        <div class="section-list"></div>
      </div>
    `;

    const listRoot = section.querySelector(".section-list");
    list.forEach((order) => listRoot.appendChild(createRow(order)));

    const toggleBtn = section.querySelector(".section-toggle");
    toggleBtn.addEventListener("click", () => toggleSection(key, section, toggleBtn));

    ordersRoot.appendChild(section);
  });

}


function toggleSection(key, section, toggleBtn) {
  const nextCollapsed = !state.collapsedSections[key];
  state.collapsedSections[key] = nextCollapsed;
  section.classList.toggle("collapsed", nextCollapsed);
  toggleBtn.setAttribute("aria-expanded", nextCollapsed ? "false" : "true");
}

function minutesFromTime(time) {
  const [h, m] = time.split(":").map(Number);
  return h * 60 + m;
}

function conciseStatus(order) {
  if (order.status === "new") return "Pending confirmation";
  if (order.status === "done") return "Completed";

  const phaseMap = {
    preparing: "Preparing",
    ready_pickup: "Ready for pickup",
    driver_arriving: "Driver arriving",
    awaiting_handoff: "Awaiting handoff"
  };
  return phaseMap[order.phase] || "Preparing";
}

function timeToneClass(time) {
  const target = minutesFromTime(time);
  const nowDate = new Date();
  const now = nowDate.getHours() * 60 + nowDate.getMinutes();
  const delta = target - now;
  if (delta < 0) return "time-late";
  if (delta < 15) return "time-urgent";
  if (delta < 30) return "time-approaching";
  return "";
}


function displayTime(order) {
  const target = minutesFromTime(order.time);
  const nowDate = new Date();
  const now = nowDate.getHours() * 60 + nowDate.getMinutes();
  const delta = target - now;

  if (order.status === "new") {
    if (delta < 0) return `Late by ${Math.abs(delta)} min`;
    if (delta < 60) return `In ${delta} min`;
  }
  return order.time;
}

function statusDotClass(order, toneClass) {
  if (toneClass === "time-late") return "status-late";
  if (order.status === "new") return "status-pending";
  if (order.status === "done") return "status-completed";
  if (order.phase === "ready_pickup") return "status-ready";
  return "status-preparing";
}

function createRow(order) {
  const row = document.createElement("article");

  const toneClass = timeToneClass(order.time);
  const statusClass = statusDotClass(order, toneClass);

  row.className = `order-row row-${order.status}`;
  row.dataset.id = order.id;

  let actionsHtml = "";
  if (order.status === "new") {
    const kitchenClosed = !state.kitchenOpen;
    actionsHtml = `<div class="row-actions row-actions-dual"><button class="decline-btn" type="button" data-action="decline" ${kitchenClosed ? "disabled" : ""}>Decline</button><button class="primary-btn" data-action="confirm" type="button" ${kitchenClosed ? "disabled" : ""}>${order.action}</button></div>`;
  } else if (order.status === "inprogress" && order.action) {
    actionsHtml = `<div class="row-actions row-actions-single"><button class="primary-btn" data-action="confirm" type="button">${order.action}</button></div>`;
  }

  row.innerHTML = `
    <div class="order-icon" aria-hidden="true">${icon(order.icon)}</div>
    <div class="row-content">
      <p class="order-title">${order.title}</p>
      <p class="order-meta"><span class="meta-customer">${order.customer}</span><span class="meta-fixed"> · #${order.id} · ${order.type}</span></p>
      <p class="order-status"><span class="status-dot ${statusClass} ${toneClass === "time-late" ? "urgent-dot" : ""}"></span>${conciseStatus(order)}</p>
      ${actionsHtml}
    </div>
    <p class="time ${toneClass}">${displayTime(order)}</p>
    <span class="row-chevron" aria-hidden="true">›</span>
  `;

  bindRowGestures(row, order);

  const confirm = row.querySelector("[data-action='confirm']");
  const decline = row.querySelector("[data-action='decline']");

  if (confirm) confirm.addEventListener("click", () => confirmOrder(order, row, confirm));
  if (decline) {
    decline.addEventListener("click", () => {
      decline.classList.add("decline-fade");
      setTimeout(() => {
        decline.classList.remove("decline-fade");
        openDeclineSheet(order.id);
      }, state.reducedMotion ? 0 : 90);
    });
  }

  row.addEventListener("click", (event) => {
    if (event.target.closest('.row-actions')) return;
    showToast(`Open order #${order.id}`);
    vibrate(8);
  });

  return row;
}

function bindRowGestures(row, order) {
  if (order.status === "done") return;
  let startX = 0;
  row.addEventListener("pointerdown", (event) => {
    startX = event.clientX;
  });
  row.addEventListener("pointerup", (event) => {
    const dx = event.clientX - startX;
    row.classList.remove("swipe-left", "swipe-right");
    if (dx > 48) {
      row.classList.add("swipe-right");
      showToast("Print receipt");
      vibrate(8);
    } else if (dx < -48) {
      row.classList.add("swipe-left");
      showToast("Call customer");
      vibrate(8);
    }
    setTimeout(() => row.classList.remove("swipe-left", "swipe-right"), state.reducedMotion ? 0 : 700);
  });
}

function confirmOrder(order, row, button) {
  button.classList.add("loading");
  button.disabled = true;
  vibrate(22);

  const delay = state.reducedMotion ? 20 : 240;
  setTimeout(() => {
    row.classList.add("flash");
    setTimeout(() => {
      row.classList.add("leaving");
      setTimeout(() => {
        order.status = "inprogress";
        order.phase = order.action === "Confirm pickup" ? "ready_pickup" : "preparing";
        renderOrders();
        showToast("Order confirmed");
      }, state.reducedMotion ? 0 : 120);
    }, state.reducedMotion ? 0 : 100);
  }, delay);
}

function openDeclineSheet(orderId) {
  state.pendingDeclineId = orderId;
  declineSheet.hidden = false;
  sheetBackdrop.hidden = false;
}

function closeDeclineSheet() {
  state.pendingDeclineId = null;
  declineSheet.hidden = true;
  sheetBackdrop.hidden = true;
}

function setupDemoIncomingOrder() {
  const delay = state.reducedMotion ? 100 : 1700;
  setTimeout(() => {
    const incoming = {
      id: "298001",
      title: "Fresh Lunch Set",
      customer: "Rama Obeid",
      type: "Delivery",
      status: "new",
      phase: "preparing",
      time: "12:18",
      action: "Confirm",
      icon: "delivery",
      urgency: true
    };
    orderModel.unshift(incoming);
    renderOrders();
    const added = document.querySelector(`.order-row[data-id="${incoming.id}"]`);
    if (added) {
      added.classList.add("entering", "arrival-flash");
      setTimeout(() => added.classList.remove("arrival-flash"), state.reducedMotion ? 0 : 500);
    }
    vibrate(12);
    setTimeout(() => vibrate(12), state.reducedMotion ? 0 : 80);
  }, delay);
}

function setupAutoRefresh() {
  setInterval(() => {
    if (state.reducedMotion) return;
    ordersRoot.classList.add("skeleton");
    setTimeout(() => {
      ordersRoot.classList.remove("skeleton");
      renderOrders();
    }, 600);
  }, 20000);
}

function showToast(text) {
  toast.textContent = text;
  toast.classList.add("show");
  setTimeout(() => toast.classList.remove("show"), state.reducedMotion ? 400 : 1400);
}

function vibrate(duration) {
  if (navigator.vibrate && !state.reducedMotion) navigator.vibrate(duration);
}

function icon(type) {
  if (type === "pickup") return '<svg viewBox="0 0 24 24"><path d="M4 7h16M6 7l1.2 10h9.6L18 7M10 10v4M14 10v4"/></svg>';
  if (type === "delivery") return '<svg viewBox="0 0 24 24"><path d="M3 7h11v8H3zM14 10h3l3 3v2h-6zM7 18a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3ZM17 18a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3Z"/></svg>';
  return '<svg viewBox="0 0 24 24"><path d="M4 12h16M7 12c0-3 2.2-5 5-5h0c2.8 0 5 2 5 5M8 12v4h8v-4"/></svg>';
}
