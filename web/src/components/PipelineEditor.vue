<template>
  <div class="editor-root">
    <header class="editor-header">
      <input
        v-model="areaName"
        class="title-input"
        :style="{ borderColor: titleFocused ? 'rgba(255,255,255,0.5)' : 'transparent' }"
        @focus="titleFocused = true"
        @blur="titleFocused = false"
      />
      <div class="header-actions">
        <button class="mini-btn action" @click="toggleActionMenu" aria-haspopup="true" :aria-expanded="showActionMenu ? 'true' : 'false'"><PlusIcon size="16" /> Action</button>
        <!-- Dropdown list for actions -->
        <div v-if="showActionMenu" class="action-dropdown" role="menu">
          <ul class="action-list">
            <li v-for="(item,i) in actionsList" :key="i" role="none">
              <button class="action-item" role="menuitem" @click="selectAction(item)">
                <span class="ai-left">
                  <span class="svc-icon" :style="{ background: services[item.service].color }">
                    <component :is="services[item.service]?.icon || defaultServiceIcon" size="14" color="white" />
                  </span>
                  <span class="ai-service">{{ services[item.service].name }}</span>
                </span>
                <span class="ai-name">{{ item.name }}</span>
              </button>
            </li>
          </ul>
        </div>
        <button class="mini-btn reaction" @click="toggleReactionMenu" aria-haspopup="true" :aria-expanded="showReactionMenu ? 'true' : 'false'"><PlusIcon size="16" /> Reaction</button>
        <div v-if="showReactionMenu" class="reaction-dropdown" role="menu">
          <ul class="action-list">
            <li v-for="(item,i) in reactionsList" :key="i" role="none">
              <button class="action-item" role="menuitem" @click="selectReaction(item)">
                <span class="ai-left">
                  <span class="svc-icon" :style="{ background: services[item.service].color }">
                    <component :is="services[item.service]?.icon || defaultServiceIcon" size="14" color="white" />
                  </span>
                  <span class="ai-service">{{ services[item.service].name }}</span>
                </span>
                <span class="ai-name">{{ item.name }}</span>
              </button>
            </li>
          </ul>
        </div>
        <button class="save-btn"><PlayIcon size="16" /> Save & Activate</button>
      </div>
    </header>
    <div class="header-grid-strip">
      <svg class="header-grid-svg" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="none">
        <defs>
          <pattern id="header-grid" width="20" height="20" patternUnits="userSpaceOnUse">
            <rect width="20" height="20" fill="var(--color-canvas)" />
            <path d="M 20 0 L 0 0 0 20" fill="none" stroke="var(--color-canvas-grid)" stroke-width="0.5" />
          </pattern>
        </defs>
        <rect width="100%" height="100%" fill="url(#header-grid)" />
      </svg>
    </div>
    <div
      ref="canvasRef"
      class="canvas"
      @click="handleCanvasClick"
      @dblclick="handleCanvasDouble"
    >
      <div class="selected-actions">
        <div
          v-for="n in orderedActionNodes"
          :key="n.id"
          class="action-card"
          :style="cardStyle(n.id)"
          @mousedown.stop="startCardDrag(n.id, $event)"
          @click.stop="selectNode(n.id)"
          :class="{ selected: selectedNode===n.id }"
        >
          <div class="action-card__header" :style="{ background: services[n.service].color }">
            <div class="action-card__header-content">
              <div class="action-card__icon" :style="{ background: 'rgba(255,255,255,0.2)' }">
                <component :is="services[n.service]?.icon || defaultServiceIcon" size="14" color="#fff" />
              </div>
              <span class="action-card__service">{{ services[n.service].name }}</span>
            </div>
            <button
              v-if="pendingDeleteId!==n.id"
              class="no-drag action-card__close"
              @click.stop="requestDelete(n.id)"
            ><XIcon size="12" color="white" /></button>
            <div v-else class="delete-confirm">
              <button class="confirm" @click.stop="confirmDelete">Confirm</button>
              <button class="cancel" @click.stop="cancelDelete">Cancel</button>
            </div>
          </div>
          <div class="action-card__body">
            <div class="action-card__title">{{ n.actionName }}</div>
            <div class="action-card__desc">{{ n.desc }}</div>
          </div>
        </div>
      </div>
      <div class="selected-reactions">
        <div
          v-for="n in orderedReactionNodes"
          :key="n.id"
          class="reaction-card"
          :style="reactionCardStyle(n.id)"
          @mousedown.stop="startReactionCardDrag(n.id, $event)"
          @click.stop="selectNode(n.id)"
        >
          <div class="reaction-card__header" :style="{ background: services[n.service].color }">
            <div class="reaction-card__header-content">
              <div class="reaction-card__icon">
                <component :is="services[n.service]?.icon || defaultServiceIcon" size="14" color="#fff" />
              </div>
              <span class="reaction-card__service">{{ services[n.service].name }}</span>
            </div>
            <button
              v-if="pendingDeleteId!==n.id"
              class="no-drag reaction-card__close"
              @click.stop="requestDelete(n.id)"
            ><XIcon size="12" color="white" /></button>
            <div v-else class="delete-confirm">
              <button class="confirm" @click.stop="confirmDelete">Confirm</button>
              <button class="cancel" @click.stop="cancelDelete">Cancel</button>
            </div>
          </div>
          <div class="reaction-card__body">
            <div class="reaction-card__title">{{ n.actionName }}</div>
            <div class="reaction-card__desc">{{ n.desc }}</div>
          </div>
        </div>
      </div>
      <div class="help">Double-click to add node • Drag nodes to move • Click connectors to link</div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount, computed, watch } from 'vue'
import { PlusIcon, PlayIcon, XIcon, MailIcon, ClockIcon, GithubIcon, MessageSquareIcon, CloudIcon, CalendarIcon } from 'lucide-vue-next'

// Data lists
const services = {
  gmail: { name: 'Gmail', color: '#EA4335', icon: MailIcon },
  timer: { name: 'Timer', color: '#4285F4', icon: ClockIcon },
  github: { name: 'GitHub', color: '#6e40c9', icon: GithubIcon },
  discord: { name: 'Discord', color: '#5865F2', icon: MessageSquareIcon },
  dropbox: { name: 'Dropbox', color: '#0061FF', icon: CloudIcon },
  outlook: { name: 'Outlook', color: '#0078D4', icon: CalendarIcon }
}
const defaultServiceIcon = PlusIcon
const actionsList = [
  { service: 'gmail', name: 'New email received', desc: 'Triggers when a new email arrives' },
  { service: 'gmail', name: 'Email with attachment', desc: 'Triggers on emails with files' },
  { service: 'timer', name: 'Schedule', desc: 'Triggers at specific times' },
  { service: 'timer', name: 'Interval', desc: 'Triggers every X minutes' },
  { service: 'github', name: 'New Issue', desc: 'Triggers on new issues' },
  { service: 'github', name: 'Pull Request', desc: 'Triggers on new PRs' }
]
const reactionsList = [
  { service: 'discord', name: 'Send Message', desc: 'Posts to #alerts' },
  { service: 'gmail', name: 'Send Email', desc: 'Sends an email' },
  { service: 'dropbox', name: 'Upload File', desc: 'Uploads a file to Dropbox' },
  { service: 'outlook', name: 'Create Event', desc: 'Creates a calendar event' },
  { service: 'github', name: 'Create Issue', desc: 'Creates a new issue' }
]
const REACTION_CANVAS_ORIGIN = { x: 460, y: 220 }

const areaName = ref('New Automation')
const titleFocused = ref(false)
const nodes = ref([
  { id: 1, type: 'action', service: 'github', actionName: 'New Issue', desc: 'Triggers on new issues', x: 100, y: 150 },
  { id: 2, type: 'reaction', service: 'discord', actionName: 'Send Message', desc: 'Posts to #alerts', x: 450, y: 150 }
])
const pendingDeleteId = ref(null)
// Maintain ordering for action nodes (cards)
const actionOrder = ref(nodes.value.filter(n => n.type==='action').map(n => n.id))
const orderedActionNodes = computed(() => actionOrder.value.map(id => nodes.value.find(n => n.id === id)).filter(Boolean))
const reactionOrder = ref(nodes.value.filter(n => n.type==='reaction').map(n => n.id))
const orderedReactionNodes = computed(() => reactionOrder.value.map(id => nodes.value.find(n => n.id === id)).filter(Boolean))

const draggingActionIndex = ref(null)
function onActionDragStart(i){ draggingActionIndex.value = i }
function onActionDrop(i){
  if (draggingActionIndex.value === null) return
  const from = draggingActionIndex.value
  const to = i
  if (from === to) { draggingActionIndex.value = null; return }
  const arr = [...actionOrder.value]
  const [moved] = arr.splice(from,1)
  arr.splice(to,0,moved)
  actionOrder.value = arr
  draggingActionIndex.value = null
}

// Dropdown state
const showActionMenu = ref(false)
const showReactionMenu = ref(false)
function toggleActionMenu() {
  showActionMenu.value = !showActionMenu.value
  if (showActionMenu.value) showReactionMenu.value = false
}
function toggleReactionMenu() {
  showReactionMenu.value = !showReactionMenu.value
  if (showReactionMenu.value) showActionMenu.value = false
}
function closeActionMenu() { showActionMenu.value = false }
function closeReactionMenu() { showReactionMenu.value = false }
function selectAction(item) {
  const count = nodes.value.filter(n => n.type === 'action').length
  const baseX = 100 + (count * 40)
  const baseY = 150
  const id = Date.now()
  nodes.value.push({ id, type: 'action', service: item.service, actionName: item.name, desc: item.desc, x: baseX, y: baseY })
  actionOrder.value.push(id)
  setInitialCardPosition(id)
  closeActionMenu()
}
function selectReaction(item) {
  const id = Date.now()
  nodes.value.push({
    id,
    type: 'reaction',
    service: item.service,
    actionName: item.name,
    desc: item.desc,
    x: REACTION_CANVAS_ORIGIN.x,
    y: REACTION_CANVAS_ORIGIN.y
  })
  reactionOrder.value.push(id)
  setInitialReactionCardPosition(id)
  closeReactionMenu()
}
function requestDelete(id) {
  pendingDeleteId.value = id
}
function cancelDelete() {
  pendingDeleteId.value = null
}
function confirmDelete() {
  if (pendingDeleteId.value != null) {
    deleteNode(pendingDeleteId.value)
    pendingDeleteId.value = null
  }
}
function handleOutside(e) {
  if (!showActionMenu.value && !showReactionMenu.value) return
  const actionMenuEl = document.querySelector('.action-dropdown')
  const actionBtnEl = document.querySelector('.mini-btn.action')
  const reactionMenuEl = document.querySelector('.reaction-dropdown')
  const reactionBtnEl = document.querySelector('.mini-btn.reaction')
  if (showActionMenu.value && !(actionMenuEl?.contains(e.target) || actionBtnEl?.contains(e.target))) {
    closeActionMenu()
  }
  if (showReactionMenu.value && !(reactionMenuEl?.contains(e.target) || reactionBtnEl?.contains(e.target))) {
    closeReactionMenu()
  }
}
onMounted(() => window.addEventListener('click', handleOutside))
onBeforeUnmount(() => window.removeEventListener('click', handleOutside))

function handleCanvasClick(e) {
  if (e.target === canvasRef.value || e.target.tagName === 'svg') {
    selectedNode.value = null
    connectingFrom.value = null
  }
}
function handleCanvasDouble(e) {
  if (e.target !== canvasRef.value && e.target.tagName !== 'svg') return
  const rect = canvasRef.value.getBoundingClientRect()
  picker.value = { x: e.clientX - rect.left, y: e.clientY - rect.top, type: 'action' }
}
function openPicker(type, x, y) { picker.value = { type, x, y } }
function addNode(item) {
  const id = Date.now()
  nodes.value.push({ id, type: picker.value.type, service: item.service, actionName: item.name, desc: item.desc, x: picker.value.x, y: picker.value.y })
  if (picker.value.type === 'action') {
    actionOrder.value.push(id)
    setInitialCardPosition(id)
  } else if (picker.value.type === 'reaction') {
    reactionOrder.value.push(id)
    setInitialReactionCardPosition(id)
  }
  picker.value = null
}
function deleteNode(id) {
  const target = nodes.value.find(n=>n.id===id)
  nodes.value = nodes.value.filter(n => n.id !== id)
  connections.value = connections.value.filter(c => c.from !== id && c.to !== id)
  if (target && target.type==='action') {
    actionOrder.value = actionOrder.value.filter(aid => aid !== id)
    const { [id]: _, ...rest } = cardPositions.value
    cardPositions.value = rest
  } else if (target && target.type==='reaction') {
    reactionOrder.value = reactionOrder.value.filter(rid => rid !== id)
    const { [id]: __, ...restReactions } = reactionCardPositions.value
    reactionCardPositions.value = restReactions
  }
  if (pendingDeleteId.value === id) pendingDeleteId.value = null
}
function selectNode(id) { selectedNode.value = id }
function startConnect(id) { connectingFrom.value = id }
function endConnect(id) {
  if (connectingFrom.value && connectingFrom.value !== id) {
    const exists = connections.value.some(c => c.from === connectingFrom.value && c.to === id)
    if (!exists) connections.value.push({ from: connectingFrom.value, to: id })
  }
  connectingFrom.value = null
}
function handleDrag(id, startEvent) {
  const startX = startEvent.clientX
  const startY = startEvent.clientY
  const node = nodes.value.find(n => n.id === id)
  const originX = node.x
  const originY = node.y
  function onMove(ev) {
    const dx = ev.clientX - startX
    const dy = ev.clientY - startY
    node.x = originX + dx
    node.y = originY + dy
  }
  function onUp() {
    window.removeEventListener('mousemove', onMove)
    window.removeEventListener('mouseup', onUp)
  }
  window.addEventListener('mousemove', onMove)
  window.addEventListener('mouseup', onUp)
}

// Card positions
const cardPositions = ref({})
const draggingCardId = ref(null)
const cardDragOffset = ref({ x: 0, y: 0 })
function getDefaultCardPosition() {
  return { x: 32, y: 24 }
}
function ensureCardPosition(id) {
  if (!id || cardPositions.value[id]) return
  cardPositions.value = { ...cardPositions.value, [id]: getDefaultCardPosition(id) }
}
watch(actionOrder, ids => ids.forEach(ensureCardPosition), { immediate: true })
function cardStyle(id) {
  const pos = cardPositions.value[id] || getDefaultCardPosition(id)
  return { left: `${pos.x}px`, top: `${pos.y}px` }
}
function startCardDrag(id, event) {
  ensureCardPosition(id)
  const current = cardPositions.value[id] || getDefaultCardPosition(id)
  cardDragOffset.value = { x: event.clientX - current.x, y: event.clientY - current.y }
  draggingCardId.value = id
  function onMove(ev) {
    if (!draggingCardId.value) return
    const x = ev.clientX - cardDragOffset.value.x
    const y = ev.clientY - cardDragOffset.value.y
    cardPositions.value = { ...cardPositions.value, [id]: { x, y } }
  }
  function onUp() {
    draggingCardId.value = null
    window.removeEventListener('mousemove', onMove)
    window.removeEventListener('mouseup', onUp)
  }
  window.addEventListener('mousemove', onMove)
  window.addEventListener('mouseup', onUp)
}

const reactionCardPositions = ref({})
const draggingReactionCardId = ref(null)
const reactionCardDragOffset = ref({ x: 0, y: 0 })
function getDefaultReactionCardPosition() {
  return { x: 32, y: 220 }
}
function ensureReactionCardPosition(id) {
  if (!id || reactionCardPositions.value[id]) return
  reactionCardPositions.value = { ...reactionCardPositions.value, [id]: getDefaultReactionCardPosition(id) }
}
watch(reactionOrder, ids => ids.forEach(ensureReactionCardPosition), { immediate: true })
function reactionCardStyle(id) {
  const pos = reactionCardPositions.value[id] || getDefaultReactionCardPosition(id)
  return { left: `${pos.x}px`, top: `${pos.y}px` }
}
function setInitialReactionCardPosition(id) {
  if (reactionCardPositions.value[id]) return
  reactionCardPositions.value = { ...reactionCardPositions.value, [id]: getDefaultReactionCardPosition(id) }
}
function startReactionCardDrag(id, event) {
  ensureReactionCardPosition(id)
  const current = reactionCardPositions.value[id] || getDefaultReactionCardPosition(id)
  reactionCardDragOffset.value = { x: event.clientX - current.x, y: event.clientY - current.y }
  draggingReactionCardId.value = id
  function onMove(ev) {
    if (!draggingReactionCardId.value) return
    const x = ev.clientX - reactionCardDragOffset.value.x
    const y = ev.clientY - reactionCardDragOffset.value.y
    reactionCardPositions.value = { ...reactionCardPositions.value, [id]: { x, y } }
  }
  function onUp() {
    draggingReactionCardId.value = null
    window.removeEventListener('mousemove', onMove)
    window.removeEventListener('mouseup', onUp)
  }
  window.addEventListener('mousemove', onMove)
  window.addEventListener('mouseup', onUp)
}
</script>

<style scoped src="@/assets/PipelineEditor.css"></style>
