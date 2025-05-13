<template>
    <div class="mb-2">
      <label :for="id" class="label block text-sm font-semibold">{{ label }}</label>
      <div
        class="flex items-center rounded-lg bg-white border border-gray-300 shadow-sm pl-3 has-[input:focus-within]:border-secondary-500"
      >
        <input
          :id="id"
          :value="modelValue"
          @input="$emit('update:modelValue', $event.target.value)"
          :type="showPassword ? 'text' : 'password'"
          :placeholder="placeholder"
          class="w-full p-2 border-0 focus:ring-0 focus:outline-none text-gray-900 text-sm"
        />
        <button
          type="button"
          @click="$emit('toggle-password')"
          class="cursor-pointer p-2 text-secondary-500 focus:outline-none"
        >
          <EyeSlashIcon v-if="showPassword" class="w-5 h-5" />
          <EyeIcon v-else class="w-5 h-5" />
        </button>
      </div>
      <p v-if="error" class="pl-1 text-sm text-red-500 mt-1">{{ error }}</p>
    </div>
  </template>
  
  <script setup>
  import { EyeIcon, EyeSlashIcon } from "@heroicons/vue/24/outline";
  
  defineProps({
    id: String,
    label: String,
    modelValue: String,
    error: String,
    placeholder: String,
    showPassword: Boolean,
  });
  defineEmits(["update:modelValue", "toggle-password"]);
  </script>