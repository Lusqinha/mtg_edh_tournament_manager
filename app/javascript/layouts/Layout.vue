<script setup>
import { Link, usePage } from '@inertiajs/vue3'
import { computed, ref } from 'vue'
import { Icon } from '@iconify/vue'
import logoWhite from '../../assets/images/logo_white.png'

const page = usePage()
const user = computed(() => page.props.auth.user)
const flash = computed(() => page.props.flash)
const organizedTournaments = computed(() => page.props.organized_tournaments || [])

const showSidebar = ref(false)
const showUserMenu = ref(false)
const showNotifications = ref(false)
const showMatchModal = ref(false)

const isUrl = (url) => {
  if (url === '/') {
    return page.url === '/'
  }
  return page.url.startsWith(url)
}

const toggleSidebar = () => showSidebar.value = !showSidebar.value
const toggleUserMenu = () => showUserMenu.value = !showUserMenu.value
const toggleNotifications = () => showNotifications.value = !showNotifications.value
const openMatchModal = () => {
  showMatchModal.value = true
  showSidebar.value = false // Close sidebar if open
}

const closeAll = () => {
  showSidebar.value = false
  showUserMenu.value = false
  showNotifications.value = false
  // Don't close modal here, it has its own close handler
}
</script>

<template>
  <div class="bg-theme-base text-theme-text font-sans antialiased min-h-screen flex flex-col overflow-x-hidden">
    <!-- Overlay -->
    <div v-if="showSidebar || showUserMenu || showNotifications" @click="closeAll" class="fixed inset-0 bg-black/50 z-40 transition-opacity"></div>

    <!-- Sidebar -->
    <aside :class="['fixed top-0 left-0 bottom-0 w-64 bg-theme-surface border-r border-theme-border z-60 transform transition-transform duration-300 ease-in-out', showSidebar ? 'translate-x-0' : '-translate-x-full']">
      <div class="p-4 border-b border-theme-border flex items-center justify-between">
        <img :src="logoWhite" alt="Liga Mesão" class="h-8 w-auto" />
        <button @click="showSidebar = false" class="text-theme-muted hover:text-theme-text">
          <Icon icon="mdi:close" class="w-6 h-6" />
        </button>
      </div>
      <nav class="p-4 space-y-2">
        <Link href="/" class="flex items-center gap-3 px-3 py-2 rounded-md hover:bg-github-btn-bg text-theme-text transition-colors" @click="showSidebar = false">
          <Icon icon="mdi:home-variant-outline" class="w-5 h-5 text-theme-muted" />
          Início
        </Link>
        <Link href="/tournaments" class="flex items-center gap-3 px-3 py-2 rounded-md hover:bg-github-btn-bg text-theme-text transition-colors" @click="showSidebar = false">
          <Icon icon="mdi:trophy-outline" class="w-5 h-5 text-theme-muted" />
          Torneios
        </Link>
        <div class="border-t border-theme-border my-2"></div>
        <template v-if="user">
          <Link :href="`/users/${user.id}`" class="flex items-center gap-3 px-3 py-2 rounded-md hover:bg-github-btn-bg text-theme-text transition-colors" @click="showSidebar = false">
            <Icon icon="mdi:account-outline" class="w-5 h-5 text-theme-muted" />
            Meu Perfil
          </Link>
          <Link href="/session" method="delete" as="button" class="w-full flex items-center gap-3 px-3 py-2 rounded-md hover:bg-red-500/10 text-red-400 transition-colors text-left" @click="showSidebar = false">
            <Icon icon="mdi:logout" class="w-5 h-5" />
            Sair
          </Link>
        </template>
        <template v-else>
          <Link href="/session/new" class="flex items-center gap-3 px-3 py-2 rounded-md hover:bg-github-btn-bg text-theme-text transition-colors" @click="showSidebar = false">
            <Icon icon="mdi:login" class="w-5 h-5 text-theme-muted" />
            Entrar
          </Link>
          <Link href="/registration/new" class="flex items-center gap-3 px-3 py-2 rounded-md hover:bg-github-btn-bg text-theme-text transition-colors" @click="showSidebar = false">
            <Icon icon="mdi:account-plus-outline" class="w-5 h-5 text-theme-muted" />
            Cadastrar
          </Link>
        </template>
      </nav>
    </aside>

    <header class="bg-theme-surface border-b border-theme-border sticky top-0 z-50">
      <div class="max-w-3xl mx-auto px-4 h-14 flex items-center justify-between">
        <div class="flex items-center gap-4">
          <button @click="toggleSidebar" class="text-theme-text hover:text-theme-secondary transition-colors">
            <Icon icon="mdi:menu" class="w-6 h-6" />
          </button>
          <Link href="/" class="flex items-center gap-2 group">
            <img :src="logoWhite" alt="Liga Mesão" class="h-8 w-auto" />
          </Link>
        </div>

        <div class="flex items-center gap-3 relative">
          <!-- Quick Match Button (Desktop) -->
          <button 
            v-if="user"
            @click="openMatchModal"
            class="hidden sm:flex items-center gap-2 px-3 py-1.5 bg-theme-primary text-white rounded-md hover:bg-theme-primary/90 transition-colors text-sm font-medium"
          >
            <Icon icon="mdi:plus" class="w-4 h-4" />
            <span>Registrar Partida</span>
          </button>

          <!-- Notifications -->
          <div class="relative">
            <button @click="toggleNotifications" class="text-theme-text hover:text-theme-secondary transition-colors relative p-1 rounded-md hover:bg-github-btn-bg">
              <Icon icon="mdi:bell-outline" class="w-5 h-5" />
              <span class="absolute top-1 right-1 w-2 h-2 bg-theme-primary rounded-full border-2 border-theme-surface"></span>
            </button>
            
            <div v-if="showNotifications" class="absolute top-full right-0 mt-2 w-64 bg-theme-surface border border-theme-border rounded-md shadow-xl py-2 z-50">
              <div class="px-4 py-2 border-b border-theme-border text-xs font-semibold text-theme-muted uppercase">Notificações</div>
              <div class="p-4 text-center text-sm text-theme-muted">
                Nenhuma notificação nova.
              </div>
            </div>
          </div>

          <!-- User Menu -->
          <div class="relative">
            <button @click="toggleUserMenu" class="text-theme-text hover:text-theme-secondary transition-colors p-1 rounded-md hover:bg-github-btn-bg">
              <Icon icon="mdi:dots-horizontal" class="w-5 h-5" />
            </button>

            <div v-if="showUserMenu" class="absolute top-full right-0 mt-2 w-48 bg-theme-surface border border-theme-border rounded-md shadow-xl py-1 z-50">
              <template v-if="user">
                <div class="px-4 py-2 border-b border-theme-border mb-1">
                  <p class="text-sm font-medium text-theme-text truncate">{{ user.nickname }}</p>
                  <p class="text-xs text-theme-muted truncate">{{ user.email_address }}</p>
                </div>
                <Link :href="`/users/${user.id}`" class="flex items-center gap-2 px-4 py-2 text-sm text-theme-text hover:bg-github-btn-bg hover:text-theme-secondary" @click="showUserMenu = false">
                  <Icon icon="mdi:account-outline" class="w-4 h-4" />
                  Perfil
                </Link>
                <Link href="/session" method="delete" as="button" class="w-full flex items-center gap-2 px-4 py-2 text-sm text-red-400 hover:bg-red-500/10 text-left" @click="showUserMenu = false">
                  <Icon icon="mdi:logout" class="w-4 h-4" />
                  Sair
                </Link>
              </template>
              <template v-else>
                <Link href="/session/new" class="flex items-center gap-2 px-4 py-2 text-sm text-theme-text hover:bg-github-btn-bg hover:text-theme-secondary" @click="showUserMenu = false">
                  <Icon icon="mdi:login" class="w-4 h-4" />
                  Entrar
                </Link>
              </template>
            </div>
          </div>
        </div>
      </div>
    </header>

    <main class="flex-1 w-full max-w-3xl mx-auto px-4 py-6 mb-16 sm:mb-0">
      <div v-if="flash.notice" class="mb-6 p-4 rounded-md bg-theme-primary/10 border border-theme-primary/40 text-theme-primary text-sm font-medium flex items-center gap-3 animate-fade-in-down">
        <Icon icon="mdi:check-circle" class="w-5 h-5 shrink-0" />
        {{ flash.notice }}
      </div>
      
      <div v-if="flash.alert" class="mb-6 p-4 rounded-md bg-red-500/10 border border-red-500/20 text-red-400 text-sm font-medium flex items-center gap-3 animate-fade-in-down">
        <Icon icon="mdi:alert-circle" class="w-5 h-5 shrink-0" />
        {{ flash.alert }}
      </div>

      <slot />
    </main>

    <!-- Bottom Navigation (Mobile) -->
    <nav v-if="user" class="sm:hidden fixed bottom-0 left-0 right-0 bg-theme-surface border-t border-theme-border pb-safe pt-2 px-2 grid grid-cols-5 items-center z-50">
      <Link href="/" class="flex flex-col items-center gap-1 p-2 text-theme-muted hover:text-theme-text" :class="{ 'text-theme-secondary': isUrl('/') }">
        <Icon icon="mdi:home-variant-outline" class="w-6 h-6" />
        <span class="text-[10px] font-medium">Início</span>
      </Link>

      <Link href="/tournaments" class="flex flex-col items-center gap-1 p-2 text-theme-muted hover:text-theme-text" :class="{ 'text-theme-secondary': isUrl('/tournaments') }">
        <Icon icon="mdi:trophy-outline" class="w-6 h-6" />
        <span class="text-[10px] font-medium">Torneios</span>
      </Link>

      <div class="flex justify-center -mt-8 relative">
        <button @click="openMatchModal" class="flex flex-col items-center justify-center">
          <div class="w-12 h-12 rounded-full bg-theme-primary text-white flex items-center justify-center shadow-lg shadow-theme-primary/40 border-4 border-theme-base">
            <Icon icon="mdi:plus" class="w-6 h-6" />
          </div>
        </button>
      </div>

      <Link :href="`/users/${user.id}`" class="flex flex-col items-center gap-1 p-2 text-theme-muted hover:text-theme-text" :class="{ 'text-theme-secondary': isUrl(`/users/${user.id}`) }">
        <Icon icon="mdi:account-outline" class="w-6 h-6" />
        <span class="text-[10px] font-medium">Perfil</span>
      </Link>

      <Link href="/session" method="delete" as="button" class="flex flex-col items-center gap-1 p-2 text-theme-muted hover:text-red-400 transition-colors">
        <Icon icon="mdi:logout" class="w-6 h-6" />
        <span class="text-[10px] font-medium">Sair</span>
      </Link>
    </nav>

    <!-- Match Registration Modal -->
    <div v-if="showMatchModal" class="fixed inset-0 z-[100] overflow-y-auto" aria-labelledby="modal-title" role="dialog" aria-modal="true">
      <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <div class="fixed inset-0 bg-black/50 transition-opacity" aria-hidden="true" @click="showMatchModal = false"></div>

        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

        <div class="inline-block align-bottom bg-theme-surface rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg w-full border border-theme-border relative z-10">
          <div class="bg-theme-surface px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
            <div class="sm:flex sm:items-start">
              <div class="mx-auto shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-theme-primary/10 sm:mx-0 sm:h-10 sm:w-10">
                <Icon icon="mdi:trophy-outline" class="h-6 w-6 text-theme-primary" />
              </div>
              <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left w-full">
                <h3 class="text-lg leading-6 font-medium text-theme-text" id="modal-title">
                  Registrar Partida
                </h3>
                <div class="mt-2">
                  <p class="text-sm text-theme-muted mb-4">
                    Selecione o torneio para o qual deseja registrar uma partida.
                  </p>
                  
                  <div v-if="organizedTournaments.length === 0" class="text-center py-4 bg-theme-bg rounded-md border border-theme-border">
                    <p class="text-sm text-theme-muted mb-2">Você não tem torneios ativos.</p>
                    <Link 
                      href="/tournaments/new" 
                      class="text-theme-primary hover:text-theme-primary/80 text-sm font-medium"
                      @click="showMatchModal = false"
                    >
                      Criar Novo Torneio
                    </Link>
                  </div>

                  <div v-else class="space-y-2 max-h-60 overflow-y-auto">
                    <Link 
                      v-for="tournament in organizedTournaments" 
                      :key="tournament.id"
                      :href="`/tournaments/${tournament.slug}/matches/new`"
                      class="flex items-center justify-between p-3 rounded-md border border-theme-border hover:bg-github-btn-bg transition-colors group"
                      @click="showMatchModal = false"
                    >
                      <span class="text-theme-text font-medium truncate">{{ tournament.name }}</span>
                      <Icon icon="mdi:chevron-right" class="w-5 h-5 text-theme-muted group-hover:text-theme-text" />
                    </Link>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="bg-theme-bg px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse border-t border-theme-border">
            <button 
              type="button" 
              class="mt-3 w-full inline-flex justify-center rounded-md border border-theme-border shadow-sm px-4 py-2 bg-theme-surface text-base font-medium text-theme-text hover:bg-github-btn-bg focus:outline-none sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm"
              @click="showMatchModal = false"
            >
              Cancelar
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>