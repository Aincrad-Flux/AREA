<script setup>
import { useRoute, useRouter } from 'vue-router'
import { computed } from 'vue'
import Sidebar from './components/Sidebar.vue'

const route = useRoute()
const router = useRouter()
const currentPage = computed(() => route.name || 'dashboard')
function goTo(page){
  if (route.name !== page) router.push({ name: page })
}
function openEditor(){ router.push({ name: 'editor' }) }
</script>

<template>
  <Sidebar :currentPage="currentPage" @update:currentPage="goTo" />
  <div class="page-shift" :class="currentPage">
    <router-view @openEditor="openEditor" />
  </div>
</template>

<style scoped>
.page-shift { margin-left:64px; min-height:100vh; }
</style>
