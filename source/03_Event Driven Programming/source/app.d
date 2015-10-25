import std.stdio;
import derelict.sdl2.sdl;
//import derelict.sdl2.image;

SDL_Window *gWindow = null;
SDL_Surface *gScreenSurface = null;
SDL_Surface *gHelloWorld = null;

bool Init(){
	DerelictSDL2.load();
	//DerelictSDL2Image.load();

	bool success = true;

	if( SDL_Init(SDL_INIT_VIDEO) < 0 ){
		writeln( "SDL init Error: ", SDL_GetError() );
		success = false;
	}
	else{
		gWindow = SDL_CreateWindow( "SDL Tutorial with D",
			SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
			640, 480, SDL_WINDOW_SHOWN );
		if( gWindow == null ){
			writeln( "Window could not be created!: ", SDL_GetError() );
			success = false;
		}
		else{
			gScreenSurface = SDL_GetWindowSurface( gWindow );
		}
	}
	return success;
}

bool loadMedia(){
	bool success = true;

	gHelloWorld = SDL_LoadBMP("hello_world.bmp");
	if( gHelloWorld == null ){
		writeln( "Unable to load iamge! : ", SDL_GetError() );
		success = false;
	}

	return success;
}

void close(){
	SDL_FreeSurface( gHelloWorld );
	gHelloWorld = null;

	SDL_DestroyWindow( gWindow );
	gWindow = null;

	SDL_Quit();
}

int main(){
	if( !Init() ){
		writeln("Failed to initialize!" );
	}
	else{
		if( !loadMedia() ){
			writeln( "Failed to load media!" );
		}
		else{
			// Main loop flag
			bool quit = false;

			// Event handler
			SDL_Event e;

			while( !quit ){
				while( SDL_PollEvent(&e) != 0 ){
					if( e.type == SDL_QUIT ){
						quit = true;
					}
				}
				SDL_BlitSurface( gHelloWorld, null, gScreenSurface, null );
				SDL_UpdateWindowSurface( gWindow );
			}

		}
	}

	close();

	return 0;
}