#!/usr/bin/bash

declare -A matrix
num_rows=8
num_cols=8
h=num_rows        # Width and Height minus 1 to avoid out-of-range indexing
w=num_cols

let num_cells=num_rows*num_cols # Total number of cells (num_cells/num_rows = columns)

# Set up matrix array with 0s
for ((y=0 ; y<num_rows ; y++)) do
    for ((x=0 ; x<num_cols ; x++)) do
        matrix[$y,$x]=0
    done
done

# Set some cells to test
matrix[1,1]=1; matrix[1,2]=1
matrix[2,1]=1; matrix[2,2]=0

# Function : Build next board state
next_board () {
    echo "Print Next Board"
    declare -A new_board
    
    # Initialize new_board with 0s
    for (( y=0 ; y<num_rows ; y++ )) do
        for (( x=0 ; x<num_cols ; x++ )) do
            new_board[$y,$x]=0  # Initialize with zeros
        done
    done
    
    neighbors=0
    # Iterate through each cell and locate neighbors
    for (( y=0 ; y<num_rows ; y++ )) do
        for (( x=0 ; x<num_cols ; x++ )) do
            neighbors=0     # Reset neighbor count for current cell
            
            echo Checking $x x $y
            # Check all eight sides for neighbors
                # TOP-LEFT
            if [[ x > 0 && y > 0 ]] && [[ ${matrix[$(( y-1 )),$(( x-1 ))]} == 1 ]]; then
                # debug print to help indicate when neighbor(s) are found
                echo "TOP-LEFT"
                ((neighbors=neighbors+1))   # Increment
            fi
                # TOP
            if [[ y > 0 ]] && [[ ${matrix[$(( y-1 )),$(( x ))]} == 1 ]]; then
                echo "TOP"
                ((neighbors=neighbors+1))
            fi
                # TOP-RIGHT
            if [[ y > 0  && x < w ]] && [[ ${matrix[$(( y-1 )),$(( x+1 ))]} == 1 ]]; then
                echo "TOP-RIGHT"
                ((neighbors=neighbors+1))
            fi
                # RIGHT
            if [[ x < w ]] && [[ ${matrix[$(( y )),$(( x+1 ))]} == 1 ]]; then
                echo "RIGHT"
                ((neighbors=neighbors+1))
            fi
                # BOTTOM-RIGHT
            if [[ x < w && y < h ]] && [[ ${matrix[$(( y + 1 )),$(( x + 1 ))]} == 1 ]]; then
                echo "BOTTOM-RIGHT"
                ((neighbors=neighbors+1))
            fi
                # BOTTOM
            if [[ y < h ]] && [[ ${matrix[$(( y+1 )),$(( x ))]} == 1 ]]; then
                echo "BOTTOM"
                ((neighbors=neighbors+1))
            fi
                # BOTTOM-LEFT
            if [[ x > 0 && y < h ]] && [[ ${matrix[$(( y+1 )),$(( x-1 ))]} == 1 ]]; then
                echo "BOTTOM-LEFT"
                ((neighbors=neighbors+1))
            fi
                # LEFT
            if [[ x > 0 ]] && [[ ${matrix[$(( y )),$(( x-1 ))]} == 1 ]]; then
                echo "LEFT ${matrix[$y,$x]}"
                ((neighbors=neighbors+1))
            fi
            echo $neighbors
            # Determine next state of the cell
            if [[ ${matrix[$y,$x]} == 1 ]] && [[ $neighbors == 3 || $neighbors == 2 ]]; then
                # Cell is alive, has 2 or 3 neighbors (keep alive)
                echo "KEEP ALIVE"
                new_board[$y,$x]=1
            elif [[ ${matrix[$y,$x]} == 0 ]] && [[ $neighbors == 3 ]] 
            then
                echo "GIVE LIFE"
                # Cell is empty and has 3 neighbors (give life)
                new_board[$y,$x]=1
            else
                echo "TAKE LIFE"
                # Center over- or under-populated (kill cell)
                new_board[$y,$x]=0
            fi
        done
    done

    # Overwrite matrix with new_board
    echo "NEW BOARD (IN LOOP)"
    for ((y=0 ; y<num_rows ; y++)) do
        for ((x=0 ; x<num_cols ; x++)) do
            matrix[$y,$x]=${new_board[$y,$x]}
            printf "%$((${#num_rows}+1))s" ${matrix[$y,$x]}
        done
        echo
    done
    echo
}

# Formatting for adding space between cells
f1="%$((${#num_rows}+1))s"
f2=" %9s"

# Print the board
for ((y=0 ; y<num_cols ; y++)) do
    for ((x=0 ; x<num_rows ; x++)) do
        printf "$f1" ${matrix[$y,$x]}
    done
    echo
done

# Call function to generate the next board state
next_board

# Print the updated board
for ((y=0 ; y<num_cols ; y++)) do
    for ((x=0 ; x<num_rows ; x++)) do
        printf "$f1" ${matrix[$y,$x]}
    done
    echo
done
