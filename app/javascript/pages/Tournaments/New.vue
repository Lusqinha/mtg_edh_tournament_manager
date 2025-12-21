<script setup>
import { useForm, Link } from '@inertiajs/vue3'
import { Icon } from '@iconify/vue'

const props = defineProps({
  tournament: Object,
  errors: Object
})

const form = useForm({
  name: '',
  number_of_rounds: '',
  max_players: '',
  tournament_scorings_attributes: props.tournament.tournament_scorings || [],
  tournament_achievements_attributes: props.tournament.tournament_achievements || []
})

const addScoring = () => {
  form.tournament_scorings_attributes.push({
    position: form.tournament_scorings_attributes.length + 1,
    points: 0
  })
}

const removeScoring = (index) => {
  form.tournament_scorings_attributes.splice(index, 1)
  // Reorder positions
  form.tournament_scorings_attributes.forEach((scoring, i) => {
    scoring.position = i + 1
  })
}

const addAchievement = () => {
  form.tournament_achievements_attributes.push({
    title: '',
    description: '',
    points: 1,
    unique_completion: false
  })
}

const removeAchievement = (index) => {
  form.tournament_achievements_attributes.splice(index, 1)
}

const submit = () => {
  form.post('/tournaments')
}
</script>

<template>
  <div class="max-w-3xl mx-auto px-4 py-8">
    <div class="flex items-center gap-3 mb-6">
      <Link href="/tournaments" class="p-1.5 rounded-md hover:bg-github-btn-bg transition-colors text-theme-muted hover:text-theme-secondary">
        <Icon icon="mdi:arrow-left" class="w-5 h-5" />
      </Link>
      <h1 class="text-xl font-semibold text-theme-text">Novo Torneio</h1>
    </div>

    <div class="p-6 rounded-md bg-theme-surface border border-theme-border shadow-sm">
      <form @submit.prevent="submit" class="space-y-8">
        <div v-if="Object.keys(form.errors).length > 0" class="p-4 rounded-md bg-red-500/10 border border-red-500/20 text-red-400 text-sm">
          <h2 class="font-semibold mb-2">Por favor corrija os seguintes erros:</h2>
          <ul class="list-disc list-inside space-y-1 opacity-80">
            <li v-for="error in form.errors" :key="error">{{ error }}</li>
          </ul>
        </div>

        <!-- Basic Info -->
        <div class="space-y-5">
          <h2 class="text-lg font-semibold text-theme-text border-b border-theme-border pb-2">Informações Básicas</h2>
          
          <div class="space-y-2">
            <label for="name" class="text-sm font-semibold text-theme-text">Nome do Torneio</label>
            <input v-model="form.name" type="text" id="name" class="w-full px-3 py-2 rounded-md bg-theme-base border border-theme-border focus:border-theme-secondary focus:ring-1 focus:ring-theme-secondary text-theme-text placeholder-theme-muted transition-all outline-none text-sm" required autofocus placeholder="Ex: Liga Commander 2025" />
            <div v-if="form.errors.name" class="text-[#ff7b72] text-xs">{{ form.errors.name }}</div>
          </div>

          <div class="grid grid-cols-2 gap-4">
            <div class="space-y-2">
              <label for="number_of_rounds" class="text-sm font-semibold text-theme-text">Número de Rodadas</label>
              <input v-model="form.number_of_rounds" type="number" id="number_of_rounds" class="w-full px-3 py-2 rounded-md bg-theme-base border border-theme-border focus:border-theme-secondary focus:ring-1 focus:ring-theme-secondary text-theme-text placeholder-theme-muted transition-all outline-none text-sm" placeholder="Opcional" />
            </div>

            <div class="space-y-2">
              <label for="max_players" class="text-sm font-semibold text-theme-text">Máximo de Jogadores</label>
              <input v-model="form.max_players" type="number" id="max_players" class="w-full px-3 py-2 rounded-md bg-theme-base border border-theme-border focus:border-theme-secondary focus:ring-1 focus:ring-theme-secondary text-theme-text placeholder-theme-muted transition-all outline-none text-sm" placeholder="Opcional" />
            </div>
          </div>
        </div>

        <!-- Scoring Rules -->
        <div class="space-y-5">
          <div class="flex items-center justify-between border-b border-theme-border pb-2">
            <h2 class="text-lg font-semibold text-theme-text">Pontuação por Posição</h2>
            <button type="button" @click="addScoring" class="text-xs text-theme-secondary hover:underline flex items-center gap-1">
              <Icon icon="mdi:plus" class="w-4 h-4" /> Adicionar Posição
            </button>
          </div>
          
          <div class="space-y-3">
            <div v-for="(scoring, index) in form.tournament_scorings_attributes" :key="index" class="flex items-center gap-4">
              <div class="w-24 flex-shrink-0">
                <span class="text-sm font-medium text-theme-text">{{ scoring.position }}º Lugar</span>
              </div>
              <div class="flex-1 flex items-center gap-2">
                <input v-model="scoring.points" type="number" class="w-20 px-3 py-1.5 rounded-md bg-theme-base border border-theme-border focus:border-theme-secondary focus:ring-1 focus:ring-theme-secondary text-theme-text outline-none text-sm" />
                <span class="text-sm text-theme-muted">pontos</span>
              </div>
              <button type="button" @click="removeScoring(index)" class="text-theme-muted hover:text-red-400 transition-colors p-1">
                <Icon icon="mdi:trash-can-outline" class="w-4 h-4" />
              </button>
            </div>
            <p class="text-xs text-theme-muted italic">Posições não listadas receberão 0 pontos.</p>
          </div>
        </div>

        <!-- Achievements -->
        <div class="space-y-5">
          <div class="flex items-center justify-between border-b border-theme-border pb-2">
            <h2 class="text-lg font-semibold text-theme-text">Conquistas (Achievements)</h2>
            <button type="button" @click="addAchievement" class="text-xs text-theme-secondary hover:underline flex items-center gap-1">
              <Icon icon="mdi:plus" class="w-4 h-4" /> Adicionar Conquista
            </button>
          </div>
          
          <div class="space-y-4">
            <div v-for="(achievement, index) in form.tournament_achievements_attributes" :key="index" class="p-4 rounded-md bg-theme-base border border-theme-border space-y-3 relative group">
              <button type="button" @click="removeAchievement(index)" class="absolute top-2 right-2 text-theme-muted hover:text-red-400 transition-colors p-1 opacity-0 group-hover:opacity-100">
                <Icon icon="mdi:close" class="w-4 h-4" />
              </button>

              <div class="grid grid-cols-1 sm:grid-cols-4 gap-3">
                <div class="sm:col-span-3 space-y-1">
                  <label class="text-xs font-semibold text-theme-muted">Título</label>
                  <input v-model="achievement.title" type="text" class="w-full px-3 py-1.5 rounded-md bg-theme-surface border border-theme-border focus:border-theme-secondary focus:ring-1 focus:ring-theme-secondary text-theme-text outline-none text-sm" placeholder="Ex: First Blood" />
                </div>
                <div class="space-y-1">
                  <label class="text-xs font-semibold text-theme-muted">Pontos</label>
                  <input v-model="achievement.points" type="number" class="w-full px-3 py-1.5 rounded-md bg-theme-surface border border-theme-border focus:border-theme-secondary focus:ring-1 focus:ring-theme-secondary text-theme-text outline-none text-sm" />
                </div>
              </div>

              <div class="space-y-1">
                <label class="text-xs font-semibold text-theme-muted">Descrição (Opcional)</label>
                <input v-model="achievement.description" type="text" class="w-full px-3 py-1.5 rounded-md bg-theme-surface border border-theme-border focus:border-theme-secondary focus:ring-1 focus:ring-theme-secondary text-theme-text outline-none text-sm" placeholder="Ex: Causar o primeiro dano de combate do jogo" />
              </div>

              <div class="flex items-center gap-2">
                <input type="checkbox" :id="`unique_${index}`" v-model="achievement.unique_completion" class="rounded bg-theme-surface border-theme-border text-theme-secondary focus:ring-theme-secondary" />
                <label :for="`unique_${index}`" class="text-xs text-theme-muted cursor-pointer select-none">
                  Apenas o primeiro jogador a realizar pontua (Único)
                </label>
              </div>
            </div>
            
                        <div v-if="form.tournament_achievements_attributes.length === 0" class="text-center p-6 border border-dashed border-theme-border rounded-md text-theme-muted text-sm">
              Nenhuma conquista cadastrada. Adicione conquistas para tornar as partidas mais dinâmicas.
            </div>
          </div>
        </div>

        <div class="pt-4 border-t border-theme-border flex justify-end gap-3">
          <Link href="/tournaments" class="px-4 py-2 rounded-md bg-github-btn-bg text-theme-text font-medium hover:bg-github-btn-hover transition-colors border border-theme-border text-sm">
            Cancelar
          </Link>
          <button type="submit" :disabled="form.processing" class="px-6 py-2 rounded-md bg-theme-primary text-white font-medium hover:bg-github-btn-primary-hover transition-colors border border-[rgba(240,246,252,0.1)] shadow-sm disabled:opacity-50 disabled:cursor-not-allowed text-sm">
            {{ form.processing ? 'Criando...' : 'Criar Torneio' }}
          </button>
        </div>
      </form>
    </div>
  </div>
</template>
