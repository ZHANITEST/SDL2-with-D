import std.stdio;
import std.string:toStringz;
import derelict.sdl2.sdl;
//import derelict.sdl2.image;

//Key press surfaces constants
enum
{
	KEY_PRESS_SURFACE_DEFAULT,
	KEY_PRESS_SURFACE_UP,
	KEY_PRESS_SURFACE_DOWN,
	KEY_PRESS_SURFACE_LEFT,
	KEY_PRESS_SURFACE_RIGHT,
	KEY_PRESS_SURFACE_TOTAL
};

SDL_Window* gWindow = null;
SDL_Surface* gScreenSurface = null;
SDL_Surface*[ KEY_PRESS_SURFACE_TOTAL ] gKeyPressSurfaces = null;
SDL_Surface* gCurrentSurface = null;

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

SDL_Surface* loadSurface( string path )
{
	//Load image at specified path
	SDL_Surface* loadedSurface = SDL_LoadBMP( path.toStringz() );
	if( loadedSurface ==null ){
		writefln( "Unable to load image %s! SDL Error: %s", path, SDL_GetError() );
	}
	return loadedSurface;
}

bool loadMedia(){
	bool success = true;

	gKeyPressSurfaces[KEY_PRESS_SURFACE_DEFAULT] = loadSurface("04_key_presses/press.bmp");
	if( gKeyPressSurfaces[KEY_PRESS_SURFACE_DEFAULT] == null ) { writeln("Failed to load default image!"); success = false; }

	gKeyPressSurfaces[KEY_PRESS_SURFACE_UP] = loadSurface("04_key_presses/up.bmp");
	if( gKeyPressSurfaces[KEY_PRESS_SURFACE_UP] == null ) { writeln("Failed to load up image!"); success = false; }

	gKeyPressSurfaces[KEY_PRESS_SURFACE_DOWN] = loadSurface("04_key_presses/down.bmp");
	if( gKeyPressSurfaces[KEY_PRESS_SURFACE_DOWN] == null ) { writeln("Failed to load down image!"); success = false; }

	gKeyPressSurfaces[KEY_PRESS_SURFACE_RIGHT] = loadSurface("04_key_presses/right.bmp");
	if( gKeyPressSurfaces[KEY_PRESS_SURFACE_RIGHT] == null ) { writeln("Failed to load right image!"); success = false; }

	gKeyPressSurfaces[KEY_PRESS_SURFACE_LEFT] = loadSurface("04_key_presses/left.bmp");
	if( gKeyPressSurfaces[KEY_PRESS_SURFACE_LEFT] == null ) { writeln("Failed to load left image!"); success = false; }

	return success;
}

void close(){
	//Deallocate surfaces
	for( int i = 0; i < KEY_PRESS_SURFACE_TOTAL; ++i )
	{
		SDL_FreeSurface( gKeyPressSurfaces[ i ] );
		gKeyPressSurfaces[ i ] = null;
	}

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

			//Set default current surface
			gCurrentSurface = gKeyPressSurfaces[ KEY_PRESS_SURFACE_DEFAULT ];

			while( !quit ){
				while( SDL_PollEvent(&e) != 0 ){
					if( e.type == SDL_QUIT ){
						quit = true;
					}
					else if( e.type == SDL_KEYDOWN ){
						//Select surfaces based on key press
						switch( e.key.keysym.sym )
						{
							case SDLK_UP:
							gCurrentSurface = gKeyPressSurfaces[ KEY_PRESS_SURFACE_UP ];
							break;

							case SDLK_DOWN:
							gCurrentSurface = gKeyPressSurfaces[ KEY_PRESS_SURFACE_DOWN ];
							break;

							case SDLK_LEFT:
							gCurrentSurface = gKeyPressSurfaces[ KEY_PRESS_SURFACE_LEFT ];
							break;

							case SDLK_RIGHT:
							gCurrentSurface = gKeyPressSurfaces[ KEY_PRESS_SURFACE_RIGHT ];
							break;

							default:
							gCurrentSurface = gKeyPressSurfaces[ KEY_PRESS_SURFACE_DEFAULT ];
							break;
						}
					}
				}
				SDL_BlitSurface( gCurrentSurface, null, gScreenSurface, null );
				SDL_UpdateWindowSurface( gWindow );
			}

		}
	}

	close();

	return 0;
}