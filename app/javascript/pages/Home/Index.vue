<script setup>
import { Link } from '@inertiajs/vue3'
</script>

<template>
  <div class="max-w-2xl mx-auto space-y-6">
    <!-- Search Bar -->
    <div class="relative">
      <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5 text-[#EEEEEE]/40">
          <path stroke-linecap="round" stroke-linejoin="round" d="M21 21l-5.197-5.197m0 0A7.5 7.5 0 105.196 5.196a7.5 7.5 0 0010.607 10.607z" />
        </svg>
      </div>
      <input type="text" placeholder="Find a league" class="w-full pl-10 pr-4 py-3 rounded-xl bg-[#393E46] border-none text-[#EEEEEE] placeholder-[#EEEEEE]/40 focus:ring-2 focus:ring-[#00ADB5] focus:outline-none shadow-sm">
    </div>

    <!-- Section Header -->
    <div class="flex items-center justify-between pt-2">
      <h2 class="text-lg font-bold text-[#EEEEEE]">Meus Torneios</h2>
      <button class="flex items-center gap-1 text-sm text-[#EEEEEE]/60 hover:text-[#EEEEEE]">
        All leagues
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4">
          <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 8.25l-7.5 7.5-7.5-7.5" />
        </svg>
      </button>
    </div>

    <!-- Cards -->
    <div class="space-y-4">
      <!-- My Tournaments Card -->
      <Link href="/tournaments" class="block bg-[#393E46] rounded-2xl p-4 shadow-lg border border-[#EEEEEE]/5 hover:border-[#00ADB5]/30 transition-all group">
        <div class="flex items-start justify-between mb-4">
          <div class="flex items-center gap-3">
            <div class="w-12 h-12 rounded-full bg-[#222831] flex items-center justify-center text-[#00ADB5] border border-[#EEEEEE]/10">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
                <path stroke-linecap="round" stroke-linejoin="round" d="M16.5 18.75h-9m9 0a3 3 0 013 3h-15a3 3 0 013-3m9 0v-3.375c0-.621-.504-1.125-1.125-1.125h-.871M7.5 18.75v-3.375c0-.621.504-1.125 1.125-1.125h.872m5.007 0H9.497m5.007 0V5.625a2.25 2.25 0 11-4.5 0v3.375M12 12h0.01" />
              </svg>
            </div>
            <div>
              <h3 class="font-bold text-[#EEEEEE] text-lg leading-tight">Meus Torneios</h3>
              <p class="text-xs text-[#EEEEEE]/60 mt-1 flex items-center gap-1">
                <span class="w-4 h-3 inline-block bg-[#00ADB5] rounded-sm"></span>
                Gerenciar competições
              </p>
            </div>
          </div>
          <span class="px-4 py-1.5 rounded-full bg-[#00ADB5] text-[#EEEEEE] text-xs font-bold group-hover:bg-[#00ADB5]/80 transition-colors">
            View
          </span>
        </div>
        
        <div class="flex items-center justify-between px-2 py-3 bg-[#222831]/50 rounded-xl">
          <div class="flex flex-col items-center gap-1">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4 text-[#EEEEEE]/40">
              <path stroke-linecap="round" stroke-linejoin="round" d="M16.5 18.75h-9m9 0a3 3 0 013 3h-15a3 3 0 013-3m9 0v-3.375c0-.621-.504-1.125-1.125-1.125h-.871M7.5 18.75v-3.375c0-.621.504-1.125 1.125-1.125h.872m5.007 0H9.497m5.007 0V5.625a2.25 2.25 0 11-4.5 0v3.375M12 12h0.01" />
            </svg>
            <span class="text-[10px] text-[#EEEEEE]/60">Torneios</span>
          </div>
          <div class="flex flex-col items-center gap-1">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4 text-[#EEEEEE]/40">
              <path stroke-linecap="round" stroke-linejoin="round" d="M18 18.72a9.094 9.094 0 003.741-.479 3 3 0 00-4.682-2.72m.94 3.198l.001.031c0 .225-.012.447-.037.666A11.944 11.944 0 0112 21c-2.17 0-4.207-.576-5.963-1.584A6.062 6.062 0 016 18.719m12 0a5.971 5.971 0 00-.941-3.197m0 0A5.995 5.995 0 0012 12.75a5.995 5.995 0 00-5.058 2.772m0 0a3 3 0 00-4.681 2.72 8.986 8.986 0 003.74.477m.94-3.197a5.971 5.971 0 00-.94 3.197M15 6.75a3 3 0 11-6 0 3 3 0 016 0zm6 3a2.25 2.25 0 11-4.5 0 2.25 2.25 0 014.5 0zm-13.5 0a2.25 2.25 0 11-4.5 0 2.25 2.25 0 014.5 0z" />
            </svg>
            <span class="text-[10px] text-[#EEEEEE]/60">Jogadores</span>
          </div>
          <div class="flex flex-col items-center gap-1">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4 text-[#EEEEEE]/40">
              <path stroke-linecap="round" stroke-linejoin="round" d="M6.75 3v2.25M17.25 3v2.25M3 18.75V7.5a2.25 2.25 0 012.25-2.25h13.5A2.25 2.25 0 0121 7.5v11.25m-18 0A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75m-18 0v-7.5A2.25 2.25 0 015.25 9h13.5A2.25 2.25 0 0121 11.25v7.5" />
            </svg>
            <span class="text-[10px] text-[#EEEEEE]/60">Calendário</span>
          </div>
        </div>
      </Link>

      <!-- Create Tournament Card -->
      <Link href="/tournaments/new" class="block bg-[#393E46] rounded-2xl p-4 shadow-lg border border-[#EEEEEE]/5 hover:border-[#00ADB5]/30 transition-all group">
        <div class="flex items-center gap-4">
          <div class="w-12 h-12 rounded-full bg-[#00ADB5]/10 flex items-center justify-center text-[#00ADB5] border border-[#00ADB5]/20 group-hover:bg-[#00ADB5] group-hover:text-[#EEEEEE] transition-colors">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
              <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
            </svg>
          </div>
          <div>
            <h3 class="font-bold text-[#EEEEEE] text-lg leading-tight">Criar Novo Torneio</h3>
            <p class="text-xs text-[#EEEEEE]/60 mt-1">Comece uma nova competição</p>
          </div>
          <div class="ml-auto">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-5 h-5 text-[#EEEEEE]/40 group-hover:text-[#00ADB5] transition-colors">
              <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
            </svg>
          </div>
        </div>
      </Link>
    </div>
  </div>
</template>