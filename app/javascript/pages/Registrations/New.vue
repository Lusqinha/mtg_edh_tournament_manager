<script setup>
import { ref, computed } from 'vue'
import { useForm, Link } from '@inertiajs/vue3'
import { Icon } from '@iconify/vue'
import logoWhite from '../../../assets/images/logo_white.png'

const form = useForm({
  nickname: '',
  password: '',
  password_confirmation: '',
})

const nicknameLength = computed(() => form.nickname.length)
const isNicknameTooLong = computed(() => form.nickname.length > 12)

const submit = () => {
  form.post('/registration')
}
</script>

<template>
  <div class="flex flex-col items-center justify-center min-h-[80vh]">
    <div class="w-full max-w-md p-8 rounded-3xl bg-[#393E46] border border-[#EEEEEE]/10 shadow-2xl">
      <div class="text-center mb-8">
        <img :src="logoWhite" alt="Liga Mesão" class="h-16 w-auto mx-auto mb-4" />
        <h1 class="text-3xl font-bold text-[#00ADB5]">Criar Conta</h1>
        <p class="text-[#EEEEEE]/60 mt-2 text-sm">Junte-se à liga e domine o mesão!</p>
      </div>

      <form @submit.prevent="submit" class="space-y-5">
        <div v-if="Object.keys(form.errors).length > 0" class="p-4 rounded-xl bg-red-500/10 border border-red-500/20 text-red-400 text-sm">
          <h2 class="font-bold mb-2">Por favor, corrija os erros abaixo:</h2>
          <ul class="list-disc list-inside space-y-1 opacity-80">
            <li v-for="error in form.errors" :key="error">{{ error }}</li>
          </ul>
        </div>

        <div class="space-y-2">
          <div class="flex items-center justify-between">
            <label for="nickname" class="text-sm font-medium text-[#EEEEEE]/80 ml-1">Nome de Usuário</label>
            <span :class="['text-xs', isNicknameTooLong ? 'text-red-400' : 'text-[#EEEEEE]/40']">
              {{ nicknameLength }}/12
            </span>
          </div>
          <div class="relative">
            <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
              <Icon icon="mdi:account" class="h-5 w-5 text-[#EEEEEE]/40" />
            </div>
            <input
              id="nickname"
              v-model="form.nickname"
              type="text"
              required
              autofocus
              maxlength="12"
              placeholder="Seu nome único"
              :class="[
                'w-full pl-11 pr-4 py-3 rounded-xl bg-[#222831] border focus:bg-[#222831] focus:ring-0 text-[#EEEEEE] placeholder-[#EEEEEE]/40 transition-all outline-none',
                isNicknameTooLong ? 'border-red-500' : 'border-transparent focus:border-[#00ADB5]'
              ]"
            />
          </div>
          <p class="text-xs text-[#EEEEEE]/40 ml-1">Pode conter letras maiúsculas e minúsculas</p>
        </div>

        <div class="grid grid-cols-2 gap-4">
          <div class="space-y-2">
            <label for="password" class="text-sm font-medium text-[#EEEEEE]/80 ml-1">Senha</label>
            <div class="relative">
              <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                <Icon icon="mdi:lock" class="h-5 w-5 text-[#EEEEEE]/40" />
              </div>
              <input id="password" v-model="form.password" type="password" required minlength="8" class="w-full pl-11 pr-4 py-3 rounded-xl bg-[#222831] border border-transparent focus:border-[#00ADB5] focus:bg-[#222831] focus:ring-0 text-[#EEEEEE] placeholder-[#EEEEEE]/40 transition-all outline-none" />
            </div>
          </div>

          <div class="space-y-2">
            <label for="password_confirmation" class="text-sm font-medium text-[#EEEEEE]/80 ml-1">Confirmar</label>
            <div class="relative">
              <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                <Icon icon="mdi:lock-check" class="h-5 w-5 text-[#EEEEEE]/40" />
              </div>
              <input id="password_confirmation" v-model="form.password_confirmation" type="password" required minlength="8" class="w-full pl-11 pr-4 py-3 rounded-xl bg-[#222831] border border-transparent focus:border-[#00ADB5] focus:bg-[#222831] focus:ring-0 text-[#EEEEEE] placeholder-[#EEEEEE]/40 transition-all outline-none" />
            </div>
          </div>
        </div>

        <button type="submit" :disabled="form.processing || isNicknameTooLong" class="w-full py-3.5 rounded-xl bg-[#00ADB5] text-[#EEEEEE] font-bold shadow-lg shadow-[#00ADB5]/20 hover:shadow-[#00ADB5]/40 hover:scale-[1.02] active:scale-[0.98] transition-all cursor-pointer mt-4 disabled:opacity-50">
          Criar Conta
        </button>
      </form>

      <div class="mt-8 text-center text-sm text-[#EEEEEE]/60">
        Já tem uma conta?
        <Link href="/session/new" class="text-[#00ADB5] font-medium hover:text-[#00ADB5]/80 ml-1">Entrar</Link>
      </div>
    </div>
  </div>
</template>