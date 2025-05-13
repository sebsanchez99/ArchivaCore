<!-- filepath: c:\dev\ArchivaCore\landing\src\modules\dashboard\components\plansSection\PaymentMethod.vue -->
<template>
  <div class="space-y-6 border rounded-xl border-primary-400 p-6">
    <div>
      <h2 class="text-xl font-semibold mb-2">Método de pago</h2>
      <div class="flex gap-4">
        <label class="flex items-center gap-2">
          <input type="radio" name="paymentMethod" value="card" :checked="modelValue === 'card'"
            @change="$emit('update:modelValue', 'card')"
            class="radio radio-primary radio-sm text-primary-500 border-primary-500 checked:bg-white " />
          Tarjeta de crédito o débito
        </label>
        <label class="flex items-center gap-2">
          <input type="radio" name="paymentMethod" value="paypal" :checked="modelValue === 'paypal'"
            @change="$emit('update:modelValue', 'paypal')"
            class="radio radio-primary radio-sm text-primary-500 border-primary-500 checked:bg-white" />
          PayPal
        </label>
      </div>
    </div>

    <!-- Formulario de tarjeta -->
    <div v-if="modelValue === 'card'" class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <!-- Nombre del titular -->
      <div class="flex flex-col w-full">
        <label for="" class="label text-sm">Nombre del titular</label>
        <label class="input bg-white border border-primary-300 focus-visible:border-0 focus-visible:ring-0">
          <UserCircleIcon class="w-5" />
          <input type="text" required placeholder="Ej: Juan Pérez" pattern="[A-Za-z][A-Za-z0-9\-]*" minlength="3"
            maxlength="30" title="Solo letras, números o guion"
/>
        </label>
      </div>

      <!-- Número de la tarjeta -->
      <div class="flex flex-col w-full">
        <label for="" class="label text-sm">Número de la tarjeta</label>
        <label class="input bg-white border border-primary-300">
          <CreditCardIcon class="w-5" />
          <input type="tel" class="tabular-nums" required placeholder="0000 0000 0000 0000" pattern="[0-9]*"
            minlength="10" maxlength="16" title="Debe contener entre 10 y 16 dígitos" />
        </label>
      </div>

      <!-- Fecha de vencimiento -->
      <div class="flex flex-col w-full">
        <label for="" class="label text-sm">Fecha de vencimiento</label>
        <label class="input bg-white border border-primary-300">
          <CalendarIcon class="w-5" />
          <input type="text" placeholder="MM/AA" title="Ej: 08/26" />
        </label>
      </div>

      <!-- CVV -->
      <div class="flex flex-col w-full">
        <label for="" class="label text-sm">Código de seguridad</label>
        <label class="input bg-white border border-primary-300">
          <CreditCardIcon class="w-5" />
          <input type="text" placeholder="Ej: 123" maxlength="4" pattern="[0-9]{3,4}"
            title="3 o 4 dígitos al reverso de la tarjeta" />
        </label>
      </div>
    </div>

    <!-- Formulario de PayPal -->
    <div v-if="modelValue === 'paypal'">
      <div class="flex flex-col">
        <label for="" class="label text-sm">Correo electrónico de PayPal</label>
        <label class="input bg-white border border-primary-300 w-full">
          <EnvelopeIcon class="w-5" />
          <input type="text" placeholder="ejemplo@paypal.com" />
        </label>
      </div>
    </div>

    <!-- Resumen de compra -->
    <div class="50 border border-primary-200 p-4 rounded-lg">
      <h3 class="text-md font-semibold mb-2 text-text-400">Resumen de compra</h3>
      <div class="text-sm text-text-400">
        <div class="flex justify-between">
          <span>Plan seleccionado</span>
          <span>{{ selectedPlan }}</span>
        </div>
        <div class="flex justify-between">
          <span>Subtotal</span>
          <span>$100</span>
        </div>
        <div class="flex justify-between">
          <span>IVA (21%)</span>
          <span>$21</span>
        </div>
        <div class="flex justify-between font-semibold border-t border-secondary-500 mt-2 pt-2 text-text-400">
          <span>Total</span>
          <span>$121</span>
        </div>
      </div>
    </div>

    <!-- Aceptación de términos -->
    <div class="flex items-center gap-2">
      <input type="checkbox" class="checkbox checkbox-primary checkbox-sm border-primary-500 checked:bg-primary-500" />
      <span class="text-sm">
        Acepto los
        <a href="#" class="link link-primary text-primary-500 hover:text-accent-500">Términos y Condiciones</a>
        y la
        <a href="#" class="link link-primary text-primary-500 hover:text-accent-500">Política de Privacidad</a>
      </span>
    </div>

    <!-- Botones de acción -->
    <div class="flex justify-end gap-3">
      <button class="btn border-none text-white bg-red-500 hover:bg-red-600" @click="$emit('cancel')">
        Cancelar
      </button>
      <button class="btn bg-primary-500 border-none text-white hover:bg-primary-600" @click="$emit('finalize')">
        Finalizar compra
      </button>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { UserCircleIcon, CreditCardIcon, CalendarIcon, EnvelopeIcon } from "@heroicons/vue/24/outline";

defineProps({
  modelValue: {
    type: String,
    required: true,
  },
  selectedPlan: {
    type: String,
    required: true,
  },
});
</script>

<style scoped>
label:focus,
label:focus-visible
{
  outline: 0px solid var(--input-color);
}

</style>
