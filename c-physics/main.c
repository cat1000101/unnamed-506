#include "raylib/include/raylib.h"

#define GRAY (Color){0x16,0x16,0x16,255}

typedef struct Point {
    Vector2 position;
    Vector2 velocity;
    double mass;
} Point;


int main(void)
{
    InitWindow(800, 450, "c-physics");

    while (!WindowShouldClose())
    {
        BeginDrawing();

        ClearBackground(GRAY);
        
        
        EndDrawing();
    }

    CloseWindow();

    return 0;
}