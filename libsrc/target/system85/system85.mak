SYSTEM85_GLOBS := \
	"target/system85/drv/*.asm" \
	"target/system85/stdio/*.asm" 

SYSTEM85_GLOBS_ex := \
	target/system85/drv/*.asm \
	target/system85/stdio/*.asm 


SYSTEM85_TARGETS := target/system85/obj/target-system85-system85 classic/gfx/obj/.stamp-system85

CLEAN += target-system85-clean
TOCREATE += $(call check_target,system85,system85_clib.lib)
$(eval $(call gfx_stamp_args,system85,TARGET=system85))
$(eval $(call buildtargetasm,target/system85,8085,system85,-m8085,$(SYSTEM85_GLOBS),$(SYSTEM85_GLOBS_ex)))

system85_clib.lib: $(TARGET_CLIB_DEPS) $(SYSTEM85_TARGETS)
	TARGET=system85 TYPE=8085 $(LIBLINKER) -m8085 -DFORsystem85 -DSTANDARDESCAPECHARS -x$(OUTPUT_DIRECTORY)/system85_clib @$(TARGET_DIRECTORY)/system85/system85.lst
		



target-system85: $(SYSTEM85_TARGETS)

.PHONY: target-system85 target-system85-clean


target-system85-clean:
	$(RM) -fr target/system85/obj
