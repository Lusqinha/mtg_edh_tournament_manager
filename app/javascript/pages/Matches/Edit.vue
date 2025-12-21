<script setup>
import { useForm, Link } from '@inertiajs/vue3'
import { computed } from 'vue'
import { Icon } from '@iconify/vue'

const props = defineProps({
  tournament: Object,
  match: Object
})

const form = useForm({
  winner_id: props.match.winner_id,
  match_results_attributes: props.match.match_results.map(result => ({
    id: result.id,
    user_id: result.user_id,
    score: result.score,
    position: result.position,
    user: result.user // Para exibição
  }))
})

const submit = () => {
  form.put(`/tournaments/${props.tournament.id}/matches/${props.match.id}`)
}
</script>

<template>
  <div class="max-w-4xl mx-auto px-4 py-8">
    <div class="mb-8">
      <h1 class="text-2xl font-semibold text-theme-text mb-2">Finalizar Partida</h1>
      <div class="flex items-center gap-2 text-theme-muted text-sm">
        <Icon icon="mdi:clock-outline" class="w-4 h-4" />
        <span>Iniciada em {{ new Date(match.played_at).toLocaleTimeString('pt-BR', {hour: '2-digit', minute:'2-digit'}) }}</span>
        <span class="w-1 h-1 rounded-full bg-theme-muted"></span>
        <span>{{ match.duration ? Math.floor(match.duration / 60) + ' min' : 'Em andamento' }}</span>
      </div>
    </div>

    <form @submit.prevent="submit" class="space-y-6">
      <div v-if="Object.keys(form.errors).length > 0" class="bg-red-500/10 border border-red-500/20 rounded-md p-4 text-red-400 text-sm">
        <h2 class="font-semibold mb-2 flex items-center gap-2">
          Por favor corrija os erros:
        </h2>
        <ul class="list-disc list-inside space-y-1 opacity-80">
          <li v-for="error in form.errors" :key="error">{{ error }}</li>
        </ul>
      </div>

      <div class="space-y-4">
        <h3 class="text-lg font-semibold text-theme-text flex items-center gap-2">
          <Icon icon="mdi:account-group" class="w-5 h-5 text-theme-muted" />
          Resultados dos Jogadores
        </h3>
        
        <div class="grid grid-cols-1 gap-4">
          <div v-for="(result, index) in form.match_results_attributes" :key="result.id" class="bg-theme-surface rounded-md border border-theme-border p-4 hover:border-theme-muted transition-all">
            <div class="flex items-center gap-3 mb-4 pb-4 border-b border-theme-border">
              <div class="w-8 h-8 rounded-full bg-github-btn-bg flex items-center justify-center text-theme-text font-bold text-sm border border-theme-border">
                {{ result.user.nickname[0].toUpperCase() }}
              </div>
              <strong class="text-base text-theme-text">{{ result.user.nickname }}</strong>
            </div>
            
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
              <div class="space-y-1">
                <label class="text-xs font-semibold text-theme-muted uppercase">Posição</label>
                <input v-model="result.position" type="number" class="w-full px-3 py-1.5 rounded-md bg-theme-base border border-theme-border focus:border-theme-secondary focus:ring-1 focus:ring-theme-secondary text-theme-text outline-none text-sm transition-all" />
              </div>
              <div class="space-y-1">
                <label class="text-xs font-semibold text-theme-muted uppercase">Pontos</label>
                <input v-model="result.score" type="number" class="w-full px-3 py-1.5 rounded-md bg-theme-base border border-theme-border focus:border-theme-secondary focus:ring-1 focus:ring-theme-secondary text-theme-text outline-none text-sm transition-all" />
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="flex flex-col sm:flex-row gap-3 pt-4 border-t border-theme-border">
        <button type="submit" :disabled="form.processing" class="flex-1 py-2 px-4 rounded-md bg-theme-primary text-white font-medium hover:bg-github-btn-primary-hover transition-colors border border-[rgba(240,246,252,0.1)] shadow-sm disabled:opacity-50 disabled:cursor-not-allowed text-sm">
          {{ form.processing ? 'Salvando...' : 'Finalizar Partida' }}
        </button>
        <Link :href="`/tournaments/${tournament.id}`" class="px-4 py-2 rounded-md bg-github-btn-bg text-theme-text font-medium hover:bg-github-btn-hover transition-colors border border-theme-border text-center text-sm">
          Cancelar
        </Link>
      </div>
    </form>
  </div>
</template>
