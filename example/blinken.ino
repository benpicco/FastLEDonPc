#define FASTLED_ESP8266_DMA

#include <Adafruit_GFX.h>
#include <FastLED.h>
#include <FastLED_NeoMatrix.h>

#define ARRAYSIZE(a) (sizeof(a) / sizeof(*a))

// fast led constants
#define DATA_PIN	3	// labeled as RX on nodeMCU
#define COLOR_ORDER	GRB	// if colors are mismatched; change this

#define M_WIDTH 	75	// the width of the LED matrix
#define M_HEIGHT	8	// the height of the LED matrix
#define NUM_LEDS	(M_WIDTH*M_HEIGHT)

#ifndef WIFI_SSID
#define WIFI_SSID	"changeme" // WiFi to connect to
#endif
#ifndef WIFI_PASS
#define WIFI_PASS	"changeme" // WiFi password
#endif

// change WS2812B to match your type of LED, if different
// list of supported types is here:
// https://github.com/FastLED/FastLED/wiki/Overview
#define LED_TYPE    SDL

static CRGB leds[NUM_LEDS];
static FastLED_NeoMatrix matrix = FastLED_NeoMatrix(leds, M_WIDTH, M_HEIGHT, NEO_MATRIX_TOP + NEO_MATRIX_LEFT + NEO_MATRIX_ROWS);
// static FastLED_NeoMatrix matrix = FastLED_NeoMatrix(leds, M_WIDTH, M_HEIGHT, NEO_MATRIX_TOP + NEO_MATRIX_LEFT + NEO_MATRIX_ROWS + NEO_MATRIX_ZIGZAG);

void setup()
{
	FastLED.addLeds<LED_TYPE, DATA_PIN, COLOR_ORDER>(leds, NUM_LEDS);
	FastLED.setCorrection(TypicalLEDStrip);
//	FastLED.setBrightness(5);	// low brightness so we can test the strip just using USB
	FastLED.clear(true);

	matrix.begin();

	Serial.println("Hello World!");
}

static const uint16_t colors[] = {
	matrix.Color(255, 0, 0),
	matrix.Color(0, 255, 0),
	matrix.Color(0, 0, 255)};

void loop()
{
	static unsigned pass;
	static int x = matrix.width();

	matrix.clear();
	matrix.setCursor(x, 0);
	matrix.print("Hello World!");

	if (--x < -(15*6)) { // roughly the width of the string
		x = matrix.width();
		if (++pass >= ARRAYSIZE(colors))
			pass = 0;
		matrix.setTextColor(colors[pass]);
	}

	matrix.show();
	delay(30);
}
