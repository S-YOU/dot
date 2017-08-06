echodry() {
    echo '   ' "$@"
}

if [ "$DRY" != "" ]; then
    DRY=1
    echo "Dry run ================================================"
    EVAL="echodry"
else
    EVAL=eval
fi
