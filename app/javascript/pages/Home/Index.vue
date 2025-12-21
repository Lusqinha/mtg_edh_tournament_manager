<script setup>
import { Link } from '@inertiajs/vue3'
import { Icon } from '@iconify/vue'
</script>

<template>
  <div class="max-w-2xl mx-auto space-y-6">
    <!-- Search Bar -->
    <div class="relative">
      <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
        <Icon icon="mdi:magnify" class="w-5 h-5 text-theme-muted" />
      </div>
      <input type="text" placeholder="Buscar torneios..." class="w-full pl-10 pr-4 py-2 rounded-md bg-theme-base border border-theme-border text-theme-text placeholder-theme-muted focus:ring-1 focus:ring-theme-secondary focus:border-theme-secondary focus:outline-none shadow-sm transition-all text-sm">
    </div>

    <!-- Section Header -->
    <div class="flex items-center justify-between pt-2">
      <h2 class="text-base font-semibold text-theme-text">Acesso Rápido</h2>
    </div>

    <!-- Cards -->
    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
      <!-- My Tournaments Card -->
      <Link href="/tournaments" class="block bg-theme-surface rounded-md p-4 shadow-sm border border-theme-border hover:border-theme-muted transition-all group">
        <div class="flex items-start justify-between mb-3">
          <div class="w-10 h-10 rounded-md bg-github-btn-bg flex items-center justify-center text-theme-text border border-theme-border group-hover:bg-theme-secondary group-hover:text-white group-hover:border-theme-secondary transition-colors">
            <Icon icon="mdi:trophy" class="w-5 h-5" />
          </div>
          <span class="px-2 py-0.5 rounded-full bg-github-btn-bg text-theme-muted text-xs font-medium border border-theme-border">
            Ver Todos
          </span>
        </div>
        <div>
          <h3 class="font-semibold text-theme-text text-base leading-tight group-hover:text-theme-secondary transition-colors">Torneios</h3>
          <p class="text-xs text-theme-muted mt-1">
            Gerencie suas ligas e competições
          </p>
        </div>
      </Link>

      <!-- New Tournament Card -->
      <Link href="/tournaments/new" class="block bg-theme-surface rounded-md p-4 shadow-sm border border-theme-border hover:border-theme-muted transition-all group">
        <div class="flex items-start justify-between mb-3">
          <div class="w-10 h-10 rounded-md bg-github-btn-bg flex items-center justify-center text-theme-text border border-theme-border group-hover:bg-theme-primary group-hover:text-white group-hover:border-theme-primary transition-colors">
            <Icon icon="mdi:plus" class="w-5 h-5" />
          </div>
          <span class="px-2 py-0.5 rounded-full bg-github-btn-bg text-theme-muted text-xs font-medium border border-theme-border">
            Criar
          </span>
        </div>
        <div>
          <h3 class="font-semibold text-theme-text text-base leading-tight group-hover:text-theme-secondary transition-colors">Novo Torneio</h3>
          <p class="text-xs text-theme-muted mt-1">
            Comece uma nova liga agora mesmo
          </p>
        </div>
      </Link>
    </div>
  </div>
</template>