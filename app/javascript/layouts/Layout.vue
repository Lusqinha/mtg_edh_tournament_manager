<script setup>
import { Link, usePage } from '@inertiajs/vue3'
import { computed } from 'vue'
import { Icon } from '@iconify/vue'
import logoWhite from '../../assets/images/logo_white.png'

const page = usePage()
const user = computed(() => page.props.auth.user)
const flash = computed(() => page.props.flash)

const isUrl = (url) => {
  if (url === '/') {
    return page.url === '/'
  }
  return page.url.startsWith(url)
}
</script>

<template>
  <div class="bg-theme-base text-theme-text font-sans antialiased min-h-screen flex flex-col">
    <header class="bg-theme-surface border-b border-theme-border sticky top-0 z-50">
      <div class="max-w-3xl mx-auto px-4 h-14 flex items-center justify-between">
        <div class="flex items-center gap-4">
          <button class="text-theme-text hover:text-theme-secondary transition-colors">
            <Icon icon="mdi:menu" class="w-6 h-6" />
          </button>
          <Link href="/" class="flex items-center gap-2 group">
            <img :src="logoWhite" alt="Liga Mesão" class="h-8 w-auto" />
          </Link>
        </div>

        <div class="flex items-center gap-3">
          <button class="text-theme-text hover:text-theme-secondary transition-colors relative p-1 rounded-md hover:bg-github-btn-bg">
            <Icon icon="mdi:bell-outline" class="w-5 h-5" />
            <span class="absolute top-1 right-1 w-2 h-2 bg-theme-primary rounded-full border-2 border-theme-surface"></span>
          </button>
          <button class="text-theme-text hover:text-theme-secondary transition-colors p-1 rounded-md hover:bg-github-btn-bg">
            <Icon icon="mdi:dots-horizontal" class="w-5 h-5" />
          </button>
        </div>
      </div>
    </header>

    <main class="flex-1 w-full max-w-3xl mx-auto px-4 py-6">
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

    <nav v-if="user" class="sm:hidden fixed bottom-0 left-0 right-0 bg-theme-surface border-t border-theme-border pb-safe pt-2 px-6 flex justify-between items-center z-50">
      <Link href="/" class="flex flex-col items-center gap-1 p-2 text-theme-muted hover:text-theme-text" :class="{ 'text-theme-secondary': isUrl('/') }">
        <Icon icon="mdi:home-variant-outline" class="w-6 h-6" />
        <span class="text-[10px] font-medium">Início</span>
      </Link>

      <Link href="/tournaments" class="flex flex-col items-center gap-1 p-2 text-theme-muted hover:text-theme-text" :class="{ 'text-theme-secondary': isUrl('/tournaments') }">
        <Icon icon="mdi:trophy-outline" class="w-6 h-6" />
        <span class="text-[10px] font-medium">Torneios</span>
      </Link>

      <Link href="/tournaments/new" class="flex flex-col items-center justify-center -mt-8">
        <div class="w-12 h-12 rounded-full bg-theme-primary text-white flex items-center justify-center shadow-lg shadow-theme-primary/40 border-4 border-theme-base">
          <Icon icon="mdi:plus" class="w-6 h-6" />
        </div>
      </Link>

      <Link :href="`/users/${user.id}`" class="flex flex-col items-center gap-1 p-2 text-theme-muted hover:text-theme-text" :class="{ 'text-theme-secondary': isUrl(`/users/${user.id}`) }">
        <Icon icon="mdi:account-outline" class="w-6 h-6" />
        <span class="text-[10px] font-medium">Perfil</span>
      </Link>
    </nav>
  </div>
</template>