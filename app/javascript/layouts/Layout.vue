<script setup>
import { Link, usePage } from '@inertiajs/vue3'
import { computed } from 'vue'

const page = usePage()
const user = computed(() => page.props.auth.user)
const flash = computed(() => page.props.flash)

const isUrl = (url) => {
  return page.url.startsWith(url)
}
</script>

<template>
  <div class="bg-[#222831] text-[#EEEEEE] font-['DM_Sans'] antialiased min-h-screen flex flex-col">
    <header class="bg-[#393E46] border-b border-[#EEEEEE]/10 sticky top-0 z-50 backdrop-blur-md bg-opacity-95">
      <div class="max-w-3xl mx-auto px-4 h-16 flex items-center justify-between">
        <div class="flex items-center gap-4">
          <button class="text-[#EEEEEE]">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
              <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5" />
            </svg>
          </button>
          <Link href="/" class="flex items-center gap-2 group">
            <span class="font-bold text-lg tracking-tight text-[#EEEEEE]">Liga Mesão</span>
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4 text-[#EEEEEE]/60">
              <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 8.25l-7.5 7.5-7.5-7.5" />
            </svg>
          </Link>
        </div>

        <div class="flex items-center gap-4">
          <button class="text-[#EEEEEE] relative">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
              <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 005.454-1.31A8.967 8.967 0 0118 9.75v-.7V9A6 6 0 006 9v.75a8.967 8.967 0 01-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 01-5.714 0m5.714 0a3 3 0 11-5.714 0" />
            </svg>
            <span class="absolute top-0 right-0 w-2 h-2 bg-[#00ADB5] rounded-full"></span>
          </button>
          <button class="text-[#EEEEEE]">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
              <path stroke-linecap="round" stroke-linejoin="round" d="M10.5 6h9.75M10.5 6a1.5 1.5 0 11-3 0m3 0a1.5 1.5 0 10-3 0M3.75 6H7.5m3 12h9.75m-9.75 0a1.5 1.5 0 01-3 0m3 0a1.5 1.5 0 00-3 0m-3.75 0H7.5m9-6h3.75m-3.75 0a1.5 1.5 0 01-3 0m3 0a1.5 1.5 0 00-3 0m-9.75 0h9.75" />
            </svg>
          </button>
        </div>
      </div>
    </header>

    <main class="flex-1 w-full max-w-3xl mx-auto px-4 py-6">
      <div v-if="flash.notice" class="mb-6 p-4 rounded-2xl bg-[#00ADB5]/10 border border-[#00ADB5]/20 text-[#00ADB5] text-sm font-medium flex items-center gap-3 animate-fade-in-down">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="w-5 h-5 flex-shrink-0">
          <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clip-rule="evenodd" />
        </svg>
        {{ flash.notice }}
      </div>
      
      <div v-if="flash.alert" class="mb-6 p-4 rounded-2xl bg-red-500/10 border border-red-500/20 text-red-400 text-sm font-medium flex items-center gap-3 animate-fade-in-down">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" class="w-5 h-5 flex-shrink-0">
          <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-8-5a.75.75 0 01.75.75v4.5a.75.75 0 01-1.5 0v-4.5A.75.75 0 0110 5zm0 10a1 1 0 100-2 1 1 0 000 2z" clip-rule="evenodd" />
        </svg>
        {{ flash.alert }}
      </div>

      <slot />
    </main>

    <nav v-if="user" class="sm:hidden fixed bottom-0 left-0 right-0 bg-[#393E46]/95 backdrop-blur-lg border-t border-[#EEEEEE]/10 pb-safe pt-2 px-6 flex justify-between items-center z-50">
      <Link href="/" class="flex flex-col items-center gap-1 p-2 text-[#EEEEEE]/60 hover:text-[#EEEEEE]" :class="{ 'text-[#00ADB5]': isUrl('/') }">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
          <path stroke-linecap="round" stroke-linejoin="round" d="M2.25 12l8.954-8.955c.44-.439 1.152-.439 1.591 0L21.75 12M4.5 9.75v10.125c0 .621.504 1.125 1.125 1.125H9.75v-4.875c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125V21h4.125c.621 0 1.125-.504 1.125-1.125V9.75M8.25 21h8.25" />
        </svg>
        <span class="text-[10px] font-medium">Início</span>
      </Link>

      <Link href="/tournaments" class="flex flex-col items-center gap-1 p-2 text-[#EEEEEE]/60 hover:text-[#EEEEEE]" :class="{ 'text-[#00ADB5]': isUrl('/tournaments') }">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
          <path stroke-linecap="round" stroke-linejoin="round" d="M16.5 18.75h-9m9 0a3 3 0 013 3h-15a3 3 0 013-3m9 0v-3.375c0-.621-.504-1.125-1.125-1.125h-.871M7.5 18.75v-3.375c0-.621.504-1.125 1.125-1.125h.872m5.007 0H9.497m5.007 0V5.625a2.25 2.25 0 11-4.5 0v3.375M12 12h0.01" />
        </svg>
        <span class="text-[10px] font-medium">Torneios</span>
      </Link>

      <Link href="/tournaments/new" class="flex flex-col items-center justify-center -mt-8">
        <div class="w-14 h-14 rounded-full bg-[#00ADB5] text-[#EEEEEE] flex items-center justify-center shadow-lg shadow-[#00ADB5]/40 border-4 border-[#222831]">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-6 h-6">
            <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
          </svg>
        </div>
      </Link>

      <button class="flex flex-col items-center gap-1 p-2 text-[#EEEEEE]/60 hover:text-[#EEEEEE]">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
          <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 6a3.75 3.75 0 11-7.5 0 3.75 3.75 0 017.5 0zM4.501 20.118a7.5 7.5 0 0114.998 0A17.933 17.933 0 0112 21.75c-2.676 0-5.216-.584-7.499-1.632z" />
        </svg>
        <span class="text-[10px] font-medium">Perfil</span>
      </button>
    </nav>
  </div>
</template>