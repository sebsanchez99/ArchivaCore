<template>
    <form class="card bg-white shadow rounded border-primary-100 flex flex-col" @submit.prevent="openUpdateModal">
        <div class="p-4 bg-primary-100">
            <h2 class="text-xl font-semibold text-text-400">Información de la cuenta</h2>
            <p class="text-sm text-text-300">Actualice la información de su cuenta</p>
        </div>
        <div class="p-6">
            <FormField id="companyName" label="Nombre de la empresa" v-model="fields.companyName"
                :placeholder="companyName" :error="errors.companyName" />
            <FormField id="fullname" label="Nombre de responsable" v-model="fields.fullname" :placeholder="fullname"
                :error="errors.fullname" />
        </div>

        <div class="px-5">
            <button
                class="btn btn-block bg-primary-500 border-none hover:bg-primary-600 text-white flex items-center justify-center gap-2"
                :disabled="settingsStore.loading">
                <span v-if="settingsStore.loading" class="loading loading-spinner loading-sm"></span>
                <span v-else>Actualizar información</span>
            </button>
        </div>

    </form>
    <InfoModal ref="updateModal" :title="'Actualizar datos'" :message="`¿Está seguro de que desea los datos?`"
        :onConfirmAction="update" :onCancelAction="handleCancel"
        alert-message="Se cerrará la sesión una vez que se actualicen los datos." />

    <SuccessModal ref="successModal" @close="resetMessages" />
    
    <ErrorModal ref="errorModal" @close="resetMessages" />
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from "vue-router";
import { useAuthStore } from "@/stores/authStore"
import { useSettingsStore } from "@/stores/settingsStore"
import { useFormValidation } from "@/composables/useFormValidation";
import { required, onlyLettersAndSpaces } from "@/utils/validators";
import FormField from '@/components/inputs/FormField.vue'
import InfoModal from "@/components/modals/InfoModal.vue"
import SuccessModal from "@/components/modals/SuccessModal.vue"
import ErrorModal from "@/components/modals/ErrorModal.vue"

const router = useRouter()
const authStore = useAuthStore()
const settingsStore = useSettingsStore()

const successModal = ref<InstanceType<typeof SuccessModal> | null>(null)
const errorModal = ref<InstanceType<typeof ErrorModal> | null>(null)
const updateModal = ref<InstanceType<typeof InfoModal> | null>(null)

const companyName = ref(authStore.getCompanyName)
const fullname = ref(authStore.getFullname)

const validators = {
    companyName: [required],
    fullname: [required, onlyLettersAndSpaces]
}

const { fields, errors, validateAll } = useFormValidation({ companyName: companyName.value, fullname: fullname.value }, validators)

function openUpdateModal() {
    const isValid = validateAll()
    if (!isValid) return
    updateModal.value?.open()
}

async function update() {
    // settingsStore.loading = true
    // await settingsStore.updateCompanyInfo(fields.companyName, fields.fullname)
    // const result = settingsStore.response?.result
    // if (result) {
    //     successModal.value?.show(getMessage('Información actualizada con éxito.'))
    //     authStore.logout()
    //     setTimeout(() => { router.push('/login') }, 2000)
    // } else {
    //     errorModal.value?.show(getMessage('No se pudo actualizar la información. Intente más tarde.'))
    // }
    // settingsStore.loading = false
}

function handleCancel() {
    updateModal.value?.close()
}

function getMessage(defaultMsg: string) {
    return settingsStore.response?.message || defaultMsg
}

function resetMessages() {
    settingsStore.resetMessages()
}

</script>