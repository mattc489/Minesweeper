import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; 
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); 

void setup () {
    size(400, 400);
    textAlign(CENTER,CENTER);
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for( int r = 0; r < NUM_ROWS; r++) {
        for ( int c = 0; c < NUM_COLS; c++) {
            buttons[r][c] = new MSButton(r, c);
        }
    }
    
    setMines();
}

public void setMines() {
    int mineCount = 0;
    while( mineCount < NUM_ROWS + NUM_COLS) {
        int randomRow = (int)(Math.random() * NUM_ROWS);
        int randomCol = (int)(Math.random() * NUM_COLS);
        if(!mines.contains(buttons[randomRow][randomCol])) {
            mines.add(buttons[randomRow][randomCol]);
            mineCount++;
        }
    }
}

public void draw () {
    background( 50, 50, 50 );  
    if(isWon() == true)
        displayWinningMessage();
}

public boolean isWon() {
    for(int r = 0; r < NUM_ROWS; r++) {
        for(int c = 0; c < NUM_COLS; c++) {
            MSButton button = buttons[r][c];
            if(!mines.contains(button) && !button.clicked) {  
                return false; 
            }
        }
    }
    return false;
}

public void displayLosingMessage() {
    for (MSButton mine : mines) {
        mine.setLabel("L");  
        mine.clicked = true;
    }

    // Display "Game Over" on all non-mine buttons
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            if (!mines.contains(buttons[r][c])) {
                buttons[r][c].setLabel("X");  
            }
        }
    }
}

public void displayWinningMessage() {
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            buttons[r][c].setLabel(":)");  
        }
    }
}

public boolean isValid(int r, int c) {
    if( r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS){
        return true;
    }
    return false;
}

public int countMines(int row, int col) {
    int numMines = 0;
    for( int r = -1; r <= 1; r++) {
        for( int c = -1; c <= 1; c++) {
            int newRow = row + r;
            int newCol = col + c;
            if( !(r == 0 && c == 0)) {
                if(isValid(newRow, newCol) && mines.contains(buttons[newRow][newCol])) {
                    numMines++;
                }
            }
        }
    }
    return numMines;
}

public class MSButton {
    private int myRow, myCol;
    private float x, y, width, height;
    private boolean clicked, flagged;
    private String myLabel;

    public MSButton(int row, int col) {
        width = 400 / NUM_COLS;
        height = 400 / NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol * width;
        y = myRow * height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); 
    }

    public void mousePressed() {
        clicked = true;
        if( mouseButton == RIGHT) {
            flagged = !flagged;
            if(!flagged) {
                return;
            }
        }
        if( flagged) {
            return;
        }
        clicked = true;
        if( mines.contains(this)) {
            displayLosingMessage();
            return;
        }
        int numMines = countMines(myRow, myCol);
        if(numMines > 0) {
            setLabel(numMines);  
        } else {
            for(int r = -1; r <= 1; r++) {
                for(int c = -1; c <= 1; c++) {
                    int newRow = myRow + r;
                    int newCol = myCol + c;
                    if(isValid(newRow, newCol)) {
                        MSButton a = buttons[newRow][newCol];
                        if(!a.clicked && !a.flagged) {
                            a.mousePressed(); 
                        }
                    }
                }
            }
        }
    }

    public void draw() {
        if (flagged) {
            fill(255, 0, 0);  
        } else if (clicked && mines.contains(this)) {
            fill(255, 0, 0);  
        } else if (clicked) {
            fill(180); 
        } else {
            fill(100, 100, 255);  
        }
        rect(x, y, width, height, 10); 

        fill(0);
        textSize(18);
        text(myLabel, x + width / 2, y + height / 2);
    }

    public void setLabel(String newLabel) {
        myLabel = newLabel;
    }

    public void setLabel(int newLabel) {
        myLabel = "" + newLabel;
    }

    public boolean isFlagged() {
        return flagged;
    }
}
