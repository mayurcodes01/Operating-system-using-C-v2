#define VIDEO_MEMORY 0xB8000
#define WHITE_ON_BLACK 0x0F

void print(const char* str) {
    char* video = (char*)VIDEO_MEMORY;
    int i = 0;

    while (str[i]) {
        video[i * 2] = str[i];
        video[i * 2 + 1] = WHITE_ON_BLACK;
        i++;
    }
}

void kernel_main() {
    print("Welcome to MyOS Kernel");
    while (1) {}
}
