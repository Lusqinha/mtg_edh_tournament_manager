<script setup>
defineProps({
  participants: Array
})
</script>

<template>
  <div class="bg-theme-surface rounded-md border border-theme-border overflow-hidden">
    <div class="overflow-x-auto custom-scrollbar">
      <table class="w-full text-sm text-left">
        <thead class="text-xs text-theme-muted uppercase bg-theme-base border-b border-theme-border">
          <tr>
            <th class="px-6 py-3 font-medium">Pos</th>
            <th class="px-6 py-3 font-medium">Jogador</th>
            <th class="px-6 py-3 font-medium text-center">Partidas</th>
            <th class="px-6 py-3 font-medium text-center">Vitórias</th>
            <th class="px-6 py-3 font-medium text-center">Win Rate</th>
            <th class="px-6 py-3 font-medium text-right">Pontos</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="(participant, index) in participants" :key="index" class="border-b border-theme-border last:border-0 hover:bg-github-btn-bg/50 transition-colors">
            <td class="px-6 py-4">
              <div :class="['w-6 h-6 flex items-center justify-center rounded-full font-bold text-xs', index === 0 ? 'bg-[#e3b341]/20 text-[#e3b341]' : (index === 1 ? 'bg-theme-muted/20 text-theme-muted' : (index === 2 ? 'bg-[#d29922]/20 text-[#d29922]' : 'bg-theme-border/50 text-theme-muted'))]">
                {{ index + 1 }}
              </div>
            </td>
            <td class="px-6 py-4 font-medium text-theme-text">{{ participant.user.nickname }}</td>
            <td class="px-6 py-4 text-center text-theme-muted">{{ participant.matches_played }}</td>
            <td class="px-6 py-4 text-center text-theme-muted">{{ participant.wins }}</td>
            <td class="px-6 py-4 text-center text-theme-muted">{{ participant.win_rate }}%</td>
            <td class="px-6 py-4 text-right font-bold text-theme-secondary">{{ participant.score }}</td>
          </tr>
          <tr v-if="participants.length === 0">
            <td colspan="6" class="px-6 py-8 text-center text-theme-muted">
              Nenhum participante registrado ainda.
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
