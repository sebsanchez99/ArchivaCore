<template>
    <div class="card shadow h-[500px] flex flex-col">
        <!-- Header -->
        <div class="bg-primary-100 text-text-700 rounded-t-md p-4">
            <div class="flex items-center justify-between">
                <div class="flex items-center gap-2">
                    <ChatBubbleBottomCenterTextIcon class="w-5 text-accent-500" />
                    <h2 class="text-lg font-semibold">Chat en vivo</h2>
                </div>
                <span class="badge text-xs border-none"
                    :class="chatStarted ? 'bg-green-500 text-white' : 'bg-primary-500 text-white'">
                    {{ chatStarted ? 'En línea' : 'Desconectado' }}
                </span>
            </div>
            <p class="text-sm opacity-80 mt-1">Tiempo de respuesta estimado: 3 minutos</p>
        </div>

        <!-- Body -->
        <div class="flex-1 overflow-hidden bg-white p-4">
            <!-- Vista antes del chat -->
            <div v-if="!chatStarted" class="flex flex-col items-center text-center h-full justify-between">
                <div>
                    <!-- Avatar -->
                    <div class="avatar mb-4">
                        <div class="bg-primary-100 text-primary-600 rounded-full p-4 shadow">
                            <UserIcon class="w-10" />
                        </div>
                    </div>
                    <h3 class="text-lg font-semibold text-text-500">Soporte instantáneo</h3>
                    <p class="text-sm text-text-400 opacity-85 max-w-xs">
                        Nuestros agentes de soporte están disponibles para ayudarlo con cualquier pregunta o problema
                        que pueda tener.
                    </p>

                    <!-- Horario -->
                    <div class="mt-4 w-full">
                        <div
                            class="flex justify-center items-center gap-2 bg-primary-100 p-2 rounded-lg text-sm text-text-400">
                            <ClockIcon class="w-5 text-accent-500"/>
                            Lunes a Viernes: 9:00 AM - 5:00 PM
                        </div>
                    </div>
                </div>

                <!-- Botón iniciar -->
                <button class="btn btn-outline bg-green-500 border-none w-full mt-4 text-white hover:bg-green-600"
                    @click="startChat">
                    <PowerIcon class="w-5 mr-2" />
                    Iniciar chat ahora
                </button>
            </div>

            <!-- Chat activo -->
            <div v-else class="flex flex-col h-full">
                <!-- Cabecera del agente -->
                <div class="pb-2 border-b border-primary-500 flex justify-between items-center">
                    <div class="flex items-center gap-3">
                        <div class="w-8 h-8 bg-primary-100 p-1 rounded-full">
                            <UserIcon class="text-primary-500" />
                        </div>
                        <div>
                            <p class="font-semibold">Agente de soporte</p>
                            <p class="text-xs text-green-500">En línea</p>
                        </div>
                    </div>
                    <button @click="endChat" class="btn btn-sm border-none bg-red-500 text-white">
                        <PowerIcon class="w-4 text-white mr-1" />
                        Finalizar chat
                    </button>
                </div>

                <!-- Mensajes -->
                <div ref="chatContainer" class="flex-1 overflow-y-auto py-4 space-y-2">
                    <div v-for="(msg, index) in messages" :key="index" :class="getMessageClass(msg.from)">
                        <div v-if="msg.from === 'agent'" class="chat-image avatar pa-3">
                            <div class="bg-accent-200 text-white rounded-full p-3 shadow font-bold">
                                AS
                            </div>
                        </div>
                        <div class="chat-header text-xs text-text-300 flex justify-between ml-2 font-semibold">
                            {{ getMessageHeader(msg.from) }}
                            <time class="ml-2">{{ msg.time }}</time>
                        </div>
                        <div class="chat-bubble text-text-400 text-sm bg-primary-100">{{ msg.text }}</div>
                    </div>
                </div>

                <!-- Input -->
                <div class="pt-2 border-t border-primary-500 flex gap-2 items-center">
                    <input v-model="input" @keyup.enter="sendMessage" type="text" placeholder="Escribe un mensaje..."
                        class="input w-full bg-white border border-primary-500" />
                    <button @click="sendMessage" class="btn btn-primary bg-primary-500 border-none">
                        <PaperAirplaneIcon class="w-5" />
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, watch, nextTick } from "vue"
import {
    ChatBubbleBottomCenterTextIcon,
    PaperAirplaneIcon,
    PowerIcon,
    ClockIcon
} from "@heroicons/vue/24/outline"
import { UserIcon } from "@heroicons/vue/24/solid"

// Reactive variables
const chatStarted = ref(false)
const input = ref("")
const messages = ref<{ text: string; time: string; from: "user" | "agent" }[]>([])
const chatContainer = ref<HTMLElement | null>(null)

// Methods
function startChat() {
    chatStarted.value = true
    addAgentMessage("Gracias por tu mensaje. Un agente responderá pronto.")
}

function endChat() {
    chatStarted.value = false
    clearChat()
}

function sendMessage() {
    if (!input.value.trim()) return
    addUserMessage(input.value)
    input.value = ""
}

function addAgentMessage(text: string) {
    addMessage(text, "agent")
}

function addUserMessage(text: string) {
    addMessage(text, "user")
}

function addMessage(text: string, from: "user" | "agent") {
    const now = new Date()
    const time = now.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" })
    messages.value.push({ text, time, from })
}

function clearChat() {
    input.value = ""
    messages.value = []
}

function getMessageClass(from: "user" | "agent") {
    return from === "agent" ? "chat chat-start" : "chat chat-end"
}

function getMessageHeader(from: "user" | "agent") {
    return from === "agent" ? "Agente Soporte" : "Tú"
}

// Auto-scroll to the latest message
watch(messages, async () => {
    await nextTick()
    if (chatContainer.value) {
        chatContainer.value.scrollTop = chatContainer.value.scrollHeight
    }
})
</script>
