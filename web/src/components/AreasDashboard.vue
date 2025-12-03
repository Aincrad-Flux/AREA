<template>
  <div class="areas-wrap">
    <div class="heading-row">
      <div>
        <h1>My Automations</h1>
        <p>Manage your AREA workflows</p>
      </div>
      <button class="new-area" @click="openEditor"><PlusIcon size="20" /> Create New Area</button>
    </div>
    <div class="areas-grid">
      <div v-for="area in areas" :key="area.id" class="area-card" @click="openEditor">
        <div class="area-head">
          <h3>{{ area.name }}</h3>
          <div class="status-dot" :class="{ active: area.active }"></div>
        </div>
        <div class="area-meta">{{ area.nodes }} nodes • {{ area.active ? 'Active' : 'Inactive' }}</div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { PlusIcon } from 'lucide-vue-next'
import { useRouter } from 'vue-router'
const router = useRouter()
function openEditor() {
  router.push({ name: 'editor' })
}
const areas = [
  { id: 1, name: 'GitHub → Discord', nodes: 2, active: true },
  { id: 2, name: 'Daily Email Report', nodes: 3, active: true },
  { id: 3, name: 'File Backup', nodes: 2, active: false }
]
</script>
<style scoped src="../assets/AreasDashboard.css"></style>
