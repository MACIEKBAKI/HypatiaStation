#define GAME_STATE_PREGAME		1
#define GAME_STATE_SETTING_UP	2
#define GAME_STATE_PLAYING		3
#define GAME_STATE_FINISHED		4

#define IS_MODE_COMPILED(MODE) (ispath(text2path("/datum/game_mode/" + MODE)))