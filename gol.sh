#!/usr/bin/bash

declare -A matrix
(( num_rows=16 ))
(( num_cols=16 ))
(( h=num_rows ))        # Width and Height minus 1 to avoid out-of-range indexing
(( w=num_cols ))

let num_cells=num_rows*num_cols # Total number of cells (num_cells/num_rows = columns)

# Set up matrix array with 0s
for ((y=0 ; y<num_rows ; y++)) do
    for ((x=0 ; x<num_cols ; x++)) do
        matrix[$y,$x]=$(( $RANDOM % 2 + 0 ))
    done
done

show_intro(){
    # Introduction
    echo " Game of Life"
    echo "-------------------------------"
    echo " At the prompt ( >>> ):"
    echo "            s - save to file"
    echo "            q - quit"
    echo "  blank enter - next generation"
    echo
}


# Function : Build next board state
next_board () {
    declare -A new_board
    
    # Initialize new_board with 0s
    for (( y=0 ; y<num_rows ; y++ )) do
        for (( x=0 ; x<num_cols ; x++ )) do
            new_board[$y,$x]=0  # Initialize with zeros
        done
    done
    
    # Iterate through each cell and locate neighbors
    for (( y=0 ; y<num_rows ; y++ )) do
        for (( x=0 ; x<num_cols ; x++ )) do
            neighbors=0     # Reset neighbor count for current cell
            
            # Check all eight sides for neighbors
                # TOP-LEFT
            if [[ x -gt 0 && y -gt 0 ]] && [[ ${matrix[$(( y-1 )),$(( x-1 ))]} == 1 ]]; then
                # debug print to help indicate when neighbor(s) are found
                ((neighbors=neighbors+1))   # Increment
            fi
                # TOP
            if [[ y -gt 0 ]] && [[ ${matrix[$(( y-1 )),$(( x ))]} == 1 ]]; then
                ((neighbors=neighbors+1))
            fi
                # TOP-RIGHT
            if [[ y -gt 0  && x -lt w ]] && [[ ${matrix[$(( y-1 )),$(( x+1 ))]} == 1 ]]; then
                ((neighbors=neighbors+1))
            fi
                # RIGHT
            if [[ x -lt w ]] && [[ ${matrix[$(( y )),$(( x+1 ))]} == 1 ]]; then
                ((neighbors=neighbors+1))
            fi
                # BOTTOM-RIGHT
            if [[ x -lt w && y -lt h ]] && [[ ${matrix[$(( y+1 )),$(( x+1 ))]} == 1 ]]; then
                ((neighbors=neighbors+1))
            fi
                # BOTTOM
            if [[ y -lt h ]] && [[ ${matrix[$(( y+1 )),$(( x ))]} == 1 ]]; then
                ((neighbors=neighbors+1))
            fi
                # BOTTOM-LEFT
            if [[ x -gt 0 && y -lt h ]] && [[ ${matrix[$(( y+1 )),$(( x-1 ))]} == 1 ]]; then
                ((neighbors=neighbors+1))
            fi
                # LEFT
            if [[ x -gt 0 ]] && [[ ${matrix[$(( y )),$(( x-1 ))]} == 1 ]]; then
                ((neighbors=neighbors+1))
            fi

            # Determine next state of the cell
            if [[ ${matrix[$y,$x]} == 1 ]] && [[ $neighbors == 3 || $neighbors == 2 ]]; then
                # Cell is alive, has 2 or 3 neighbors (keep alive)
                new_board[$y,$x]=1
            elif [[ ${matrix[$y,$x]} == 0 ]] && [[ $neighbors == 3 ]] 
            then
                # Cell is empty and has 3 neighbors (give life)
                new_board[$y,$x]=1
            else
                # Center over- or under-populated (kill cell)
                new_board[$y,$x]=0
            fi
        done
    done

    # Overwrite matrix with new_board
    for ((y=0 ; y<num_rows ; y++)) do
        for ((x=0 ; x<num_cols ; x++)) do
            matrix[$y,$x]=${new_board[$y,$x]}
        done
    done
}

print_board(){
    for ((y=0 ; y<num_rows ; y++)) do
        for ((x=0 ; x<num_cols ; x++)) do
            printf "%2s" ${matrix[$y,$x]}
        done
        echo
    done
}

# Save current board state to numbered txt file
save_file(){
    # prefix="board"
    number=0
    fname="board-01.txt"
    while [ -e "$fname" ]; do
        printf -v fname '%s-%02d.txt' "board" "$(( ++number ))"
    done
    for ((y=0 ; y<num_rows ; y++)) do
        for ((x=0 ; x<num_cols ; x++)) do
            printf ${matrix[$y,$x]} >> $fname
        done
        if [[ $y -ne $num_rows-1 ]]; then
            printf "\n" >> $fname
        fi
    done   
}

show_intro

read -p "How many generations? : " generations
generation=0

while [ $(( generation )) -lt $generations ]; do
    echo Generation $(( generation + 1 ))
    print_board
    (( generation++ ))
    if [[ $generation == $generations ]]; then
        break
    else
        
        read -p ">>> " input
        if [[ $input == "s" ]]; then
            save_file
        elif [[ $input == "q" ]]; then
            break
        else
            next_board
        fi
    fi
done
