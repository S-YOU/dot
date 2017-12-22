#===================================================================
#	Configuration
#===================================================================

# 最終生成物
BIN		= a.out

CC      =   gcc
MODE    =   debug	# debug or release
INCLUDE =   -I.
ifeq ($(MODE),release)
CFLAGS  =   -W -Wall -Wno-unused-parameter -pedantic -O2 -DRELEASE $(INCLUDE)
else
CFLAGS  =   -W -Wall -Wno-unused-parameter -pedantic -g -O0 -DDEBUG $(INCLUDE)
endif
LDFLAGS =   -L. -lm


#===================================================================
#	Rules
#===================================================================

# Put all auto generated stuff to this build dir.
BUILD_DIR = ./build

# ソースファイル
SRCS = $(wildcard *.c)

# All .o files go to build dir.
OBJ = $(SRCS:%.c=$(BUILD_DIR)/%.o)
# Gcc/Clang will create these .d files containing dependencies.
DEP = $(OBJ:%.o=%.d)

.PHONY: all
all: $(BUILD_DIR)/$(BIN)

# Actual target of the binary - depends on all .o files.
$(BUILD_DIR)/$(BIN) : $(OBJ)
	@mkdir -p $(@D)
	$(CC) $(LDFLAGS) $^ -o $@

# Include all .d files
-include $(DEP)

# Build target for every single object file.
# The potential dependency on header files is covered
# by calling `-include $(DEP)`.
$(BUILD_DIR)/%.o : %.c
	@mkdir -p $(@D)
# The -MMD flags additionaly creates a .d file with the same name as the .o file.
	$(CC) $(CFLAGS) -MMD -c $< -o $@

.PHONY: clean
clean :
	rm -rf $(BUILD_DIR)/$(BIN) $(OBJ) $(DEP)
