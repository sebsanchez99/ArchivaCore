<template>
    <div class="flex-1 flex flex-col h-full">
        <div v-if="!chat" class="flex flex-col items-center justify-center flex-1 text-center text-primary-600">
            <div class="avatar mb-4">
                <div class="w-20 rounded-full bg-primary-100 p-4">
                    <ChatBubbleBottomCenterTextIcon class="text-primary-600 w-12 h-12" />
                </div>
            </div>
            <h3 class="text-xl font-semibold">Selecciona un chat</h3>
            <p class="text-sm text-primary-500">Aquí podrás ver y responder mensajes de los clientes</p>
        </div>

        <div v-else class="flex flex-col h-full">
            <!-- Cabecera -->
            <div class="pb-2 border-b border-primary-500 flex justify-between items-center">
                <div class="flex items-center gap-3">
                    <div class="w-8 h-8 bg-gray-200 rounded-full">
                        <UserIcon class="text-primary-500" />
                    </div>
                    <div>
                        <p class="font-semibold text-primary-600">{{ chat.name }}</p>
                        <p class="text-xs" :class="chat.online ? 'text-green-500' : 'text-gray-400'">
                            {{ chat.online ? 'En línea' : 'Desconectado' }}
                        </p>
                    </div>
                </div>
                <button @click="endChat" class="btn btn-sm border-none bg-red-500 text-white">
                    <PowerIcon class="w-4 text-white mr-1" />
                    Finalizar chat
                </button>
            </div>

            <!-- Mensajes -->
            <div ref="chatContainer" class="flex-1 overflow-y-auto py-4 space-y-4">
                <div v-for="(msg, index) in chat.messages" :key="index" :class="getMessageClass(msg.from)">
                    <template v-if="msg.from === 'user'">
                        <!-- Avatar del cliente -->
                        <div class="chat-image avatar mr-2">
                            <div
                                class="bg-primary-500 text-white rounded-full font-bold p-3 shadow">
                                {{ getInitials(chat.name) }}
                            </div>
                        </div>
                    </template>

                    <div>
                        <!-- Cabecera -->
                        <div class="chat-header text-xs text-primary-600 flex justify-between ml-2 font-semibold">
                            {{ msg.from === 'agent' ? 'Agente Soporte' : chat.name }}
                            <time class="ml-2">{{ msg.time }}</time>
                        </div>
                        <!-- Burbuja de mensaje -->
                        <div class="chat-bubble text-primary-700 text-sm bg-primary-100">
                            {{ msg.text }}
                        </div>
                    </div>
                </div>
            </div>


            <!-- Input -->
            <div class="pt-2 border-t border-primary-500 flex gap-2 items-center">
                <input v-model="input" @keyup.enter="sendMessage" type="text" placeholder="Escribe un mensaje..."
                    class="input w-full bg-white border border-primary-500" />
                <button @click="sendMessage" class="btn btn-primary">
                    <PaperAirplaneIcon class="w-5" />
                </button>
            </div>
        </div>
    </div>
</template>

<script setup lang="ts">
import { ref, watch, nextTick } from "vue"
import {
    ChatBubbleBottomCenterTextIcon,
    PaperAirplaneIcon,
    PowerIcon
} from "@heroicons/vue/24/outline"
import { UserIcon } from "@heroicons/vue/24/solid"

interface ChatMessage {
    text: string
    time: string
    from: "user" | "agent"
}
interface Chat {
    id: number
    name: string
    online: boolean
    time: string
    messages: ChatMessage[]
}

const props = defineProps<{ chat: Chat | null }>()

const input = ref("")
const chatContainer = ref<HTMLElement | null>(null)

function sendMessage() {
    if (!input.value.trim() || !props.chat) return
    props.chat.messages.push({
        text: input.value,
        time: new Date().toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" }),
        from: "agent"
    })
    input.value = ""
}

function endChat() {
    input.value = ""
    if (props.chat) {
        props.chat.messages = []
    }
}

function getInitials(name: string) {
  return name.trim().substring(0, 2).toUpperCase()
}


function getMessageClass(from: "user" | "agent") {
  return from === "agent" ? "chat chat-end" : "chat chat-start"
}

watch(() => props.chat?.messages, async () => {
    await nextTick()
    if (chatContainer.value) {
        chatContainer.value.scrollTop = chatContainer.value.scrollHeight
    }
})
</script>