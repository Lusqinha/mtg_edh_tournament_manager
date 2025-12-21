<script setup>
import { useForm } from '@inertiajs/vue3'

const props = defineProps({
  show: Boolean,
  availableUsers: Array,
  tournamentId: Number
})

const emit = defineEmits(['close'])

const form = useForm({
  user_id: ''
})

const submit = () => {
  form.post(`/tournaments/${props.tournamentId}/participants`, {
    onSuccess: () => {
      emit('close')
      form.reset()
    }
  })
}
</script>

<template>
  <div v-if="show" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-theme-base/80 backdrop-blur-sm">
    <div class="bg-theme-surface rounded-md border border-theme-border shadow-xl w-full max-w-md p-6">
      <h3 class="text-lg font-semibold text-theme-text mb-4">Adicionar Jogador</h3>
      
      <form @submit.prevent="submit" class="space-y-4">
        <div class="space-y-2">
          <label for="user_id" class="text-sm font-semibold text-theme-text">Selecione o Jogador</label>
          <select id="user_id" v-model="form.user_id" class="w-full px-3 py-2 rounded-md bg-theme-base border border-theme-border focus:border-theme-secondary focus:ring-1 focus:ring-theme-secondary text-theme-text outline-none appearance-none text-sm" required>
            <option value="" disabled>Selecione um jogador...</option>
            <option v-for="user in availableUsers" :key="user.id" :value="user.id">
              {{ user.nickname }}
            </option>
          </select>
          <div v-if="form.errors.user_id" class="text-[#ff7b72] text-xs">{{ form.errors.user_id }}</div>
        </div>

        <div class="flex gap-3 pt-2">
          <button type="submit" :disabled="form.processing" class="flex-1 py-2 rounded-md bg-theme-primary text-white font-medium hover:bg-github-btn-primary-hover transition-colors cursor-pointer disabled:opacity-50 border border-[rgba(240,246,252,0.1)] shadow-sm text-sm">
            {{ form.processing ? 'Adicionando...' : 'Adicionar' }}
          </button>
          <button type="button" @click="$emit('close')" class="px-4 py-2 rounded-md bg-github-btn-bg text-theme-text font-medium hover:bg-github-btn-hover transition-colors border border-theme-border text-sm">
            Cancelar
          </button>
        </div>
      </form>
    </div>
  </div>
</template>
