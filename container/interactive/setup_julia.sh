#!/bin/bash

function init_packages {
    JULIA_VER=$1
    /opt/julia-${JULIA_VER}/bin/julia -e "Pkg.init()"
}

function include_packages {
    JULIA_VER=$1
    PKG_LIST=$2
    METHOD=$3
    for PKG in $PKG_LIST
    do
        echo ""
        echo "$METHOD package $PKG to Julia $JULIA_VER ..."
        /opt/julia-${JULIA_VER}/bin/julia -e "Pkg.${METHOD}(\"$PKG\")"
        if [ $METHOD == 'build' ]; then
          /opt/julia-${JULIA_VER}/bin/julia -e "Base.compilecache($PKG)"
          /opt/julia-${JULIA_VER}/bin/julia -e "eval(parse(\"using $PKG\"))"
        fi
    done
}


function list_packages {
    JULIA_VER=$1
    echo ""
    echo "Listing packages for Julia $JULIA_VER ..."
    /opt/julia-${JULIA_VER}/bin/julia -e 'println("JULIA_HOME: $JULIA_HOME\n"); versioninfo(); println(""); Pkg.status()' > /opt/julia_packages/julia-${JULIA_VER}.packages.txt
}

# Install packages for Julia 0.4, 0.5, and 0.6-dev
INTERNAL_PACKAGES="https://github.com/tanmaykm/JuliaBoxUtils.jl.git"
DEFAULT_PACKAGES="IJulia PyPlot Interact Colors SymPy PyCall Requests Plots StatPlots FreqTables DataFrames DecisionTree PlotlyJS MultivariateStats"
BUILD_PACKAGES="JuliaBoxUtils IJulia PyPlot Requests Plots StatPlots FreqTables DataFrames DecisionTree PlotlyJS MultivariateStats"

for ver in 0.3 0.4 0.5 0.6
do
    init_packages "$ver"
    include_packages "$ver" "$DEFAULT_PACKAGES" "add"
    include_packages "$ver" "$INTERNAL_PACKAGES" "clone"
    include_packages "$ver" "$BUILD_PACKAGES" "build"
    list_packages "$ver"
done
