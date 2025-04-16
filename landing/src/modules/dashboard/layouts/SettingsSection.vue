<template>
    <div class="max-w-6xl mx-auto flex flex-col gap-6 ">
        <div>
            <h2 class="text-2xl font-bold text-primary-800 mb-1">Configuración</h2>
            <p class="text-sm text-primary-600">Administra tu cuenta y preferencias</p>
        </div>
        <div class="grid grid-cols-2 gap-4">
            <UpdateInfoForm />
            <ChangePasswordForm />
        </div>
        <DeleteAccountForm />
    </div>
</template>

<script setup lang="ts">
import UpdateInfoForm from "@/modules/dashboard/components/settingsSection/UpdateInfoForm.vue";
import ChangePasswordForm from "@/modules/dashboard/components/settingsSection/ChangePasswordForm.vue";
import DeleteAccountForm from "@/modules/dashboard/components/settingsSection/DeleteAccountForm.vue";
</script>