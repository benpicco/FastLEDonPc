BUILD_ROOT ?= build

$(shell mkdir -p $(BUILD_ROOT))

CFLAGS += -Wall -Wextra
CFLAGS += -DARDUINO=101
CFLAGS += -DFASTLED_SDL $(shell sdl2-config --cflags)

LDFLAGS += $(shell sdl2-config --libs)
LDFLAGS += -Wl,--gc-sections

DEPDIR := $(BUILD_ROOT)
DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.Td
POSTCOMPILE = @mv -f $(DEPDIR)/$*.Td $(DEPDIR)/$*.d && touch $@

define add_lib
SRC_C    := $(shell find $1 -name '*.c' | sort -k 1nr | cut -f2-)
SRC_CXX  := $(shell find $1 -name '*.cpp' | sort -k 1nr | cut -f2-)

OBJECTS += $(SRC_C:%.c=$(BUILD_ROOT)/%.o)
OBJECTS += $(SRC_CXX:%.cpp=$(BUILD_ROOT)/%.o)

INCLUDES += -I$1
endef

$(eval $(call add_lib,src/cores/arduino))
$(eval $(call add_lib,src/system))

ifneq ($(strip $(ARDUINO_LIBS)),)
$(foreach lib, $(ARDUINO_LIBS), $(eval $(call add_lib,libraries/$(lib))))
endif

INCLUDES += $(foreach d, $(INC_DIR), -I$d)

OBJECTS += $(BUILD_ROOT)/main.o

main: $(OBJECTS)
	$(CXX) $(OBJECTS) $(LDFLAGS) -o $@

print:
	@echo "BUILD_ROOT:\t $(BUILD_ROOT)"
	@echo "INCLUDES:\t $(INCLUDES)"
	@echo "OBJECTS:\t $(OBJECTS)"

$(BUILD_ROOT)/%.o : %.c $(DEPDIR)/%.d
	mkdir -p `dirname $@`
	$(CC) $(DEPFLAGS) $(CFLAGS) $(INCLUDES) -c $<
	$(POSTCOMPILE)

$(BUILD_ROOT)/%.o : %.cpp $(DEPDIR)/%.d
	mkdir -p `dirname $@`
	$(CXX) $(DEPFLAGS) $(CFLAGS) $(INCLUDES) -c $<
	$(POSTCOMPILE)

$(DEPDIR)/%.d: ;
.PRECIOUS: $(DEPDIR)/%.d

SRCS = $(SRC_C) + $(SRC_CXX)
include $(wildcard $(patsubst %,$(DEPDIR)/%.d,$(basename $(SRCS))))
