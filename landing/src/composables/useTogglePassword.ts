import { ref } from "vue";
export function useTogglePassword() {
    const showPassword = ref<boolean>(false);

    const togglePassword = (): void => {
        showPassword.value = !showPassword.value;
    };

    return {
        showPassword,
        togglePassword,
    };
}