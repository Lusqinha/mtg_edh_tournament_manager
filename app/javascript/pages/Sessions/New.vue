<script setup>
import { useForm, Link } from '@inertiajs/vue3'

const form = useForm({
  login: '',
  password: '',
})

const submit = () => {
  form.post('/session')
}
</script>

<template>
  <div class="flex flex-col items-center justify-center min-h-[80vh]">
    <div class="w-full max-w-md p-8 rounded-3xl bg-[#393E46] border border-[#EEEEEE]/10 shadow-2xl">
      <div class="text-center mb-8">
        <h1 class="text-3xl font-bold text-[#00ADB5]">Entrar</h1>
        <p class="text-[#EEEEEE]/60 mt-2 text-sm">Bem-vindo de volta, comandante!</p>
      </div>

      <form @submit.prevent="submit" class="space-y-6">
        <div class="space-y-2">
          <label for="login" class="text-sm font-medium text-[#EEEEEE]/80 ml-1">Email ou Apelido</label>
          <input id="login" v-model="form.login" type="text" required autofocus autocomplete="username" placeholder="Seu email ou apelido" class="w-full px-4 py-3 rounded-xl bg-[#222831] border border-transparent focus:border-[#00ADB5] focus:bg-[#222831] focus:ring-0 text-[#EEEEEE] placeholder-[#EEEEEE]/40 transition-all outline-none" />
          <div v-if="form.errors.login" class="text-red-500 text-xs mt-1">{{ form.errors.login }}</div>
        </div>

        <div class="space-y-2">
          <div class="flex justify-between items-center">
            <label for="password" class="text-sm font-medium text-[#EEEEEE]/80 ml-1">Senha</label>
            <Link href="/passwords/new" class="text-xs text-[#00ADB5] hover:text-[#00ADB5]/80">Esqueceu a senha?</Link>
          </div>
          <input id="password" v-model="form.password" type="password" required autocomplete="current-password" placeholder="Sua senha" maxlength="72" class="w-full px-4 py-3 rounded-xl bg-[#222831] border border-transparent focus:border-[#00ADB5] focus:bg-[#222831] focus:ring-0 text-[#EEEEEE] placeholder-[#EEEEEE]/40 transition-all outline-none" />
          <div v-if="form.errors.password" class="text-red-500 text-xs mt-1">{{ form.errors.password }}</div>
        </div>

        <button type="submit" :disabled="form.processing" class="w-full py-3.5 rounded-xl bg-[#00ADB5] text-[#EEEEEE] font-bold shadow-lg shadow-[#00ADB5]/20 hover:shadow-[#00ADB5]/40 hover:scale-[1.02] active:scale-[0.98] transition-all cursor-pointer disabled:opacity-50">
          Entrar
        </button>
      </form>

      <div class="mt-8 text-center text-sm text-[#EEEEEE]/60">
        Não tem uma conta? 
        <Link href="/registrations/new" class="text-[#00ADB5] font-medium hover:text-[#00ADB5]/80 ml-1">Criar conta</Link>
      </div>
    </div>
  </div>
</template>