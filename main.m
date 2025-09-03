% Clear command window and audio
clc
clear sound

% Initialize game engine object
gameplayLevel1 = simpleGameEngine('retro_pack.png',16,16,5,[20,120,35]);


% LEVEL 1

% Initialize sprites with correct png location
entrance_sprite = 3*32 + 12;
blank_sprite = 1;
all_water_sprite = 5*32 + 9;
player = 28;
downstream_sprite = 4*32 + 9;
tree1_sprite = 34;
tree2_sprite = 33;
goodpath_sprite = 5;
alrightpath_sprite = 4;
badpath_sprite = 2;
rampup_sprite = 15*32 + 11;
rampflat_sprite = 15*32 + 12;
rampdown_sprite = 15*32 + 13;
pond_sprite = 5*32 + 15;
shrub1_sprite = 65;
shrub2_sprite = 66;
snake_sprite = 8*32 + 29;
enemy1 = 6*32 + 32;
key = 23*32 + 17;

% Background layer
movementLayer = blank_sprite * ones(11,11);

% Foreground (movement) layer
backgroundLayer = blank_sprite * ones(11,11);
drawScene(gameplayLevel1, movementLayer)

% River
backgroundLayer(:,7)= downstream_sprite;

% Level unlocking item
movementLayer(10,9) = key;

% Path
backgroundLayer(6,1)= goodpath_sprite;
backgroundLayer(5,1)= alrightpath_sprite;
backgroundLayer(7,1)= alrightpath_sprite;
backgroundLayer(5,2)= alrightpath_sprite;
backgroundLayer(6,2)= goodpath_sprite;
movementLayer(5,2)= player;
backgroundLayer(4,2)= badpath_sprite;
backgroundLayer(4,3)= alrightpath_sprite;
backgroundLayer(5,3)= goodpath_sprite;
backgroundLayer(6,3)= alrightpath_sprite;
backgroundLayer(4,4)= goodpath_sprite;
backgroundLayer(5,4)= goodpath_sprite;
backgroundLayer(5,5)= badpath_sprite;
backgroundLayer(4,5)= goodpath_sprite;
backgroundLayer(3,5)= badpath_sprite;
backgroundLayer(3,6)= badpath_sprite;
backgroundLayer(5,6)= badpath_sprite;
backgroundLayer(4,6)= rampup_sprite;
backgroundLayer(4,7)= rampflat_sprite;
backgroundLayer(4,8)= rampdown_sprite;
backgroundLayer(3,8)= badpath_sprite;
backgroundLayer(5,8)= badpath_sprite;
backgroundLayer(3,9)= alrightpath_sprite;
backgroundLayer(4,9)= goodpath_sprite;
backgroundLayer(5,9)= alrightpath_sprite;
backgroundLayer(4,10)= alrightpath_sprite;
backgroundLayer(2,9)= goodpath_sprite;
backgroundLayer(2,10)= alrightpath_sprite;
backgroundLayer(1,11)= goodpath_sprite;
backgroundLayer(1,9)= goodpath_sprite;
backgroundLayer(2,10)= goodpath_sprite;
backgroundLayer(2,11)= goodpath_sprite;
backgroundLayer(3,10)= goodpath_sprite;
backgroundLayer(3,11)= goodpath_sprite;
backgroundLayer(1,10)= entrance_sprite;
backgroundLayer(4,5)= snake_sprite;

% Trees and shrubbery
backgroundLayer(3,2)= tree1_sprite;
backgroundLayer(2,3)= shrub2_sprite;
backgroundLayer(8,3)= tree2_sprite;
backgroundLayer(8,5)= pond_sprite;
backgroundLayer(7,6)= shrub1_sprite;
backgroundLayer(9,6)= shrub2_sprite;
backgroundLayer(10,2)= tree1_sprite;
backgroundLayer(8,10)= tree1_sprite;
backgroundLayer(10,9)= shrub2_sprite;
backgroundLayer(7,9)= tree2_sprite;
backgroundLayer(1,5)= tree1_sprite;

% Enemies
movementLayer(6, 10) = enemy1;

% Player's initial location level 1
cPlayerPositionR = 5;
cPlayerPositionC = 2;

% Enemy1 initial location
cEnemy1PositionR = 6;
cEnemy1PositionC = 10;

% Display initial player health text
playerHealthText = 'HEALTH:';
playerHealthNumber = '100';
playerHealthDisplay = strcat(playerHealthText, {' '}, playerHealthNumber);
t4 = text(740, 900, playerHealthDisplay);
t4.FontSize = 18;

% Display initial enemy health
enemyHealthText = 'ENEMY HEALTH:';
enemyHealthNumber = '20';
enemyHealthDisplay = strcat(enemyHealthText, {' '}, enemyHealthNumber);
t5 = text(740, 940, enemyHealthDisplay);
t5.FontSize = 18;

% Display battle messages
playerWinMessage = 'You strike down the enemy with a';
enemyWinMessage = 'The enemy hits you with a';
tieMessage = 'Your attacks counter each other equally!';
enemyDefeatedMessage = 'Enemy defeated!';
t6 = text(740, 940, {' '});

% Display game over message
gameOverMessage = 'You died! Game over!';

% Display snake dialogue
snakeLine1 = 'What are you doing around here, boy?';
snakeLine2 = 'Oh, you want the gold... just like the rest of them.';
snakeLine3 = 'Well, to get the gold, you must solve the puzzles ahead...';
snakeLine4 = 'And defeat any enemies in your path...';
snakeLine5 = 'Good luck, son... be careful...';

% Set enemy movement dictator
move = 0;

% Set frame rate
framerate = 12;

% Level unlocker condition
hasKey1 = false;

% Boolean describing if player has talked with snake yet (prevents
% repetition of dialogue)
talkWithSnake = false;

% Initial player and enemy health
playerHealth = 100;
enemyHealth = 20;

% Determines if enemy and player are dead (stops movement if true)
enemyDead = false;
playerDead = false;

% Start level 1 soundtrack
[y, Fs] = audioread("01 - Title Theme.mp3");
sound(y, Fs);



% LEVEL 1

while(1)
    tic

    gameplayLevel1.my_figure.KeyPressFcn = @(src,event)guidata(src,event.Key);
    gameplayLevel1.my_figure.KeyReleaseFcn = @(src,event)guidata(src,'0');
    key_down = guidata(gameplayLevel1.my_figure);
    keyInput = string(key_down);

    % Update scene
    drawScene(gameplayLevel1,backgroundLayer,movementLayer)


    % WASD four-directional movement
    if playerDead == false
        if keyInput ~= '0'
            % Takes s to move down and checks current player column position to prevent
            % user from going into river while on bridge
            if (keyInput == 's') && (cPlayerPositionC ~= 7) && (cPlayerPositionR ~= 11)
                if ((cPlayerPositionR == 3) && (cPlayerPositionC == 6)) || ((cPlayerPositionR == 3) && (cPlayerPositionC == 8))
                    % block movement
                else
                    cPlayerPositionR = cPlayerPositionR + 1;
                    iPlayerPositionR = cPlayerPositionR - 1;
                    movementLayer(iPlayerPositionR,cPlayerPositionC) = 1;
                    movementLayer(cPlayerPositionR,cPlayerPositionC) = player;
                end
                % Takes w to move up and checks current player column position to prevent
                % user from going into river while on bridge
            elseif keyInput == 'w'  && (cPlayerPositionC ~= 7) && (cPlayerPositionR ~= 1)
                if ((cPlayerPositionR == 5) && (cPlayerPositionC == 6)) || ((cPlayerPositionR == 5) && (cPlayerPositionC == 8))
                    % block movement
                else
                    cPlayerPositionR = cPlayerPositionR - 1;
                    iPlayerPositionR = cPlayerPositionR + 1;
                    movementLayer(iPlayerPositionR,cPlayerPositionC) = 1;
                    movementLayer(cPlayerPositionR,cPlayerPositionC) = player;
                end
                % Takes d to move right and checks column position to prevent user
                % from crossing river
            elseif (keyInput == 'd') && (cPlayerPositionC ~= 11)
                % Check for movement blocker from river and allow user to cross
                % river
                if (cPlayerPositionC == 6) && (cPlayerPositionR ~= 4)
                    % block movement
                else
                    cPlayerPositionC = cPlayerPositionC + 1;
                    iPlayerPositionC = cPlayerPositionC - 1;
                    movementLayer(cPlayerPositionR,iPlayerPositionC) = 1;
                    movementLayer(cPlayerPositionR,cPlayerPositionC) = player;
                end
                % Takes a to move left and checks column position to prevent user
                % from crossing river
            elseif (keyInput == 'a') && (cPlayerPositionC ~= 1)
                if (cPlayerPositionC == 8) && (cPlayerPositionR ~= 4)
                    % block movement
                else
                    cPlayerPositionC = cPlayerPositionC - 1;
                    iPlayerPositionC = cPlayerPositionC + 1;
                    movementLayer(cPlayerPositionR,iPlayerPositionC) = 1;
                    movementLayer(cPlayerPositionR,cPlayerPositionC) = player;
                end
            end

            % Allows player to collect key used to move on to the next level
            if (cPlayerPositionR == 10) && (cPlayerPositionC == 9)
                hasKey1 = true;
            end

            % Allows player to move on to the next level if they have gotten the
            % key (they also must have killed the enemy)
            if ((hasKey1 == true) && ((cPlayerPositionR == 1) && (cPlayerPositionC == 10))) && (enemyDead == true)
                close
                break;
            end

            % Snake dialogue at beginning of game/directions prompted by
            % being in front of snake
            if (talkWithSnake == false) && ((cPlayerPositionR == 4) && (cPlayerPositionC == 4))
                delete(t6);
                t6 = text(0, 940, snakeLine1);
                t6.FontSize = 18;
                pause(3.5)
                delete(t6);
                t6 = text(0, 940, snakeLine2);
                t6.FontSize = 18;
                pause(3.5)
                delete(t6);
                t6 = text(0, 940, snakeLine3);
                t6.FontSize = 18;
                pause(3.5)
                delete(t6);
                t6 = text(0, 940, snakeLine4);
                t6.FontSize = 18;
                pause(3.5)
                delete(t6);
                t6 = text(0, 940, snakeLine5);
                t6.FontSize = 18;
                pause(3.5)
                delete(t6);
                backgroundLayer(4,5) = 1;
                talkWithSnake = true;
            end
        end
    end

    % Calculate random direction for enemy1 to move
    randomMovement1 = randi(4);

    % Check which direction to move enemy1 using random number (below has
    % same movement restrictors as the player, plus preventing them from
    % moving off the grid). Only allows movement when move = 0, which is
    % calculated below
    if enemyDead == false
        if keyInput == '0'
            % move enemy1 down
            if ((randomMovement1 == 1) && (cEnemy1PositionC ~= 7)) && (cEnemy1PositionR ~= 11)
                if move == 0
                    cEnemy1PositionR = cEnemy1PositionR + 1;
                    iEnemy1PositionR = cEnemy1PositionR - 1;
                    movementLayer(iEnemy1PositionR,cEnemy1PositionC) = 1;
                    movementLayer(cEnemy1PositionR, cEnemy1PositionC) = enemy1;
                end
                % move enemy1 up
            elseif ((randomMovement1 == 2) && (cEnemy1PositionC ~= 7)) && (cEnemy1PositionR ~= 1)
                if move == 0
                    cEnemy1PositionR = cEnemy1PositionR - 1;
                    iEnemy1PositionR = cEnemy1PositionR + 1;
                    movementLayer(iEnemy1PositionR,cEnemy1PositionC) = 1;
                    movementLayer(cEnemy1PositionR, cEnemy1PositionC) = enemy1;
                end
                % move enemy1 right
            elseif (randomMovement1 == 3) && (cEnemy1PositionC ~= 11)
                if move == 0
                    if (cEnemy1PositionC == 6) && (cEnemy1PositionR ~= 4)
                        % block enemy1 movement
                    else
                        cEnemy1PositionC = cEnemy1PositionC + 1;
                        iEnemy1PositionC = cEnemy1PositionC - 1;
                        movementLayer(cEnemy1PositionR,iEnemy1PositionC) = 1;
                        movementLayer(cEnemy1PositionR, cEnemy1PositionC) = enemy1;
                    end
                end
                % move enemy1 left
            elseif (randomMovement1 == 4) && (cEnemy1PositionC ~= 1)
                if move == 0
                    if (cEnemy1PositionC == 8) && (cEnemy1PositionR ~= 4)
                        % block enemy1 movement
                    else
                        cEnemy1PositionC = cEnemy1PositionC - 1;
                        iEnemy1PositionC = cEnemy1PositionC + 1;
                        movementLayer(cEnemy1PositionR,iEnemy1PositionC) = 1;
                        movementLayer(cEnemy1PositionR, cEnemy1PositionC) = enemy1;
                    end

                end
            end
        end
    end

    % If current player position and current enemy position match, fighting
    % enemy mechanic begins (rock paper scissors system)
    if (cPlayerPositionR == cEnemy1PositionR) && (cPlayerPositionC == cEnemy1PositionC)

        % Displays fighting options for player to choose from as text below
        % the screen (punch beats fireball, kick beats punch, and fireball beats
        % kick)
        kickText = 'KICK(1)';
        punchText = 'PUNCH(2)';
        fireballText = 'FIREBALL(3)';

        t1 = text(0, 900, kickText);
        t2 = text(100, 900, punchText);
        t3 = text(230, 900, fireballText);
        t1.FontSize = 18;
        t2.FontSize = 18;
        t3.FontSize = 18;

        while (playerHealth > 0)
            % Determine enemy's random attack
            enemyAttack = randi(3);

            % Determine user's attack
            userAttack = getKeyboardInput(gameplayLevel1);

            % Determine winner (if player wins, enemy loses random number of
            % health between 0 and 25, if enemy wins, player loses random
            % number of health between 0 and 10, and if it is a tie, nothing
            % happens
            winner = determineWinner(userAttack, enemyAttack);

            % Calculates number of damage to subtract from loser's health
            playerDamage = randi(15);
            enemyDamage = randi(20);

            % Subtracts health from enemy and user according to the winner,
            % also updating screen
            if winner == 1
                delete(t5)
                enemyHealth = enemyHealth - enemyDamage;
                enemyHealthNumber = int2str(enemyHealth);
                enemyHealthDisplay = strcat(enemyHealthText, {' '}, enemyHealthNumber);
                t5 = text(740, 940, enemyHealthDisplay);
                t5.FontSize = 18;
                % Displays proper battle message to screen (player)
                if userAttack == 49
                    delete(t6)
                    finalWinDisplay = strcat(playerWinMessage, {' '}, 'kick!');
                    t6 = text(0, 940, finalWinDisplay);
                    t6.FontSize = 18;
                elseif userAttack == 50
                    delete(t6)
                    finalWinDisplay = strcat(playerWinMessage, {' '}, 'punch!');
                    t6 = text(0, 940, finalWinDisplay);
                    t6.FontSize = 18;
                elseif userAttack == 51
                    delete(t6)
                    finalWinDisplay = strcat(playerWinMessage, {' '}, 'fireball!');
                    t6 = text(0, 940, finalWinDisplay);
                    t6.FontSize = 18;
                end
            elseif winner == -1
                delete(t4)
                playerHealth = playerHealth - playerDamage;
                playerHealthNumber = int2str(playerHealth);
                playerHealthDisplay = strcat(playerHealthText, {' '}, playerHealthNumber);
                t4 = text(740, 900, playerHealthDisplay);
                t4.FontSize = 18;
                % Displays proper battle message to screen (enemy)
                if enemyAttack == 1
                    delete(t6)
                    finalWinDisplay = strcat(enemyWinMessage, {' '}, 'kick!');
                    t6 = text(0, 940, finalWinDisplay);
                    t6.FontSize = 18;
                elseif enemyAttack == 2
                    delete(t6)
                    finalWinDisplay = strcat(enemyWinMessage, {' '}, 'punch!');
                    t6 = text(0, 940, finalWinDisplay);
                    t6.FontSize = 18;
                elseif enemyAttack == 3
                    delete(t6)
                    finalWinDisplay = strcat(enemyWinMessage, {' '}, 'fireball!');
                    t6 = text(0, 940, finalWinDisplay);
                    t6.FontSize = 18;
                end
            else
                % Display tie message
                delete(t6)
                t6 = text(0, 940, tieMessage);
                t6.FontSize = 18;
            end

            % Check if enemy or player has died
            if enemyHealth <= 0
                delete(t6)
                enemyHealth = 0;
                delete(t5)
                enemyHealthNumber = int2str(enemyHealth);
                enemyHealthDisplay = strcat(enemyHealthText, enemyHealthNumber);
                t5 = text(740, 940, enemyHealthDisplay);
                t5.FontSize = 18;
                movementLayer(cEnemy1PositionR,cEnemy1PositionC) = player;
                enemyDead = true;
                drawScene(gameplayLevel1,backgroundLayer,movementLayer)
                t6 = text(0, 940, enemyDefeatedMessage);
                t6.FontSize = 18;
                break;
            elseif playerHealth <= 0
                delete(t6)
                movementLayer(cEnemy1PositionR,cEnemy1PositionC) = enemy1;
                playerDead = true;
                drawScene(gameplayLevel1,backgroundLayer,movementLayer)
                t6 = text(0, 940, gameOverMessage);
                t6.FontSize = 18;
                break;
            end
        end
    end

    % Increment and calculate movement dictator (move variable must be zero
    % from move mod 20 in order for enemy to move)
    move = move + 1;
    move = mod(move, 4);

    pause(1/framerate-toc)
end

% Stop level 1 audio
clear sound

% Start level 2 audio
[y, Fs] = audioread("Sound_15658.mp3");
sound(y, Fs);












% LEVEL 2

gameplayLevel2 = simpleGameEngine('retro_pack.png',16,16,5,[45,0,0]);

% Initialize sprites with correct png location
leftpath = 53;
rightpath = 51;
middlepath = 52;
rightcorner = 85;
bottompath = 84;
toppath = 20;
leftcorner = 83;
box = 201;
door = 526;
bat = 283;
plate = 494;
fire = 336;
pad = 562;
fire2 = 486;
grass = 86;
fireplace = 335;
player = 28;
bones1_sprite = 481;
bones2_sprite = 482;
bones3_sprite = 786;
grave1 = 449;
grave2 = 450;
grave3 = 451;
rightarrow = 661;
leftarrow = 663;

% Background layer for level 2
backgroundLayer2 = ones(20,20);
backgroundLayer2(12:20,11) = leftpath;
backgroundLayer2(12:19,10) = middlepath;
backgroundLayer2(12:20,9) = rightpath;
backgroundLayer2(10:11,11) = leftpath;
backgroundLayer2(9,14:20) = bottompath;
backgroundLayer2(8,14:20) = middlepath;
backgroundLayer2(7,12:20) = toppath;
backgroundLayer2(10:11,9) = rightpath;
backgroundLayer2(9,7:8) = bottompath;
backgroundLayer2(9,12:13) = bottompath;
backgroundLayer2(10,10) = middlepath;
backgroundLayer2(9,1:6) = bottompath;
backgroundLayer2(8,1:6) = middlepath;
backgroundLayer2(7,1:8) = toppath;
backgroundLayer2(3:6,11) = leftpath;
backgroundLayer2(2,11) = middlepath;
backgroundLayer2(3:6,10) = middlepath;
backgroundLayer2(3:6,9) = rightpath;
backgroundLayer2(2,9) = middlepath;
backgroundLayer2(2,10) = middlepath;
backgroundLayer2(1,9:11) = door;
backgroundLayer2(1,8) = fireplace;
backgroundLayer2(1,12) = fireplace;
backgroundLayer2(20,8) = fire2;
backgroundLayer2(20,12) = fire2;
backgroundLayer2(2,12) = pad;
backgroundLayer2(2,8) = pad;
backgroundLayer2(8,7:20) = middlepath;
backgroundLayer2(7,9:11) = middlepath;
backgroundLayer2(9,9:11) = middlepath;
backgroundLayer2(8,10) = fireplace;
backgroundlayer2(9,10) = middlepath;
backgroundLayer2(11,10) = middlepath;
backgroundLayer2(6,20) = rightarrow;
backgroundLayer2(10,1) = leftarrow;
backgroundLayer2(12, 17) = bones1_sprite;

movementLayer2 = ones(20,20);
movementLayer2(20,10) = player;
movementLayer2(12,2) = bones1_sprite;
movementLayer2(2,18) = bones1_sprite;
movementLayer2(2,2) = bones2_sprite;
movementLayer2(17,13) = bones3_sprite;
movementLayer2(4,14) = bones3_sprite;
movementLayer2(15,6) = bones2_sprite;
movementLayer2(3, 5) = grave1;
movementLayer2(5,16) = grave2;
movementLayer2(18, 19) = grave1;
movementLayer2(16,2) = grave2;

drawScene(gameplayLevel2, backgroundLayer2, movementLayer2)

% Player's initial location level 2
cPlayerPositionR = 20;
cPlayerPositionC = 10;

% Start level 2 loop
while 1
    tic

    gameplayLevel2.my_figure.KeyPressFcn = @(src,event)guidata(src,event.Key);
    gameplayLevel2.my_figure.KeyReleaseFcn = @(src,event)guidata(src,'0');
    key_down = guidata(gameplayLevel2.my_figure);
    keyInput = string(key_down);

    % Update scene
    drawScene(gameplayLevel2,backgroundLayer2,movementLayer2)

    % WASD four-direction movement
    if playerDead == false
        if keyInput ~= '0'
            if (keyInput == 's') && (cPlayerPositionR ~= 20)
                if (cPlayerPositionR == 9) && ((cPlayerPositionC ~= 9) && (cPlayerPositionC ~= 10) && (cPlayerPositionC ~= 11))
                    % do nothing
                else
                    cPlayerPositionR = cPlayerPositionR + 1;
                    iPlayerPositionR = cPlayerPositionR - 1;
                    movementLayer2(iPlayerPositionR,cPlayerPositionC) = 1;
                    movementLayer2(cPlayerPositionR,cPlayerPositionC) = player;
                end
            elseif keyInput == 'w' && (cPlayerPositionR ~= 1)
                if (cPlayerPositionR == 7) && ((cPlayerPositionC ~= 9) && (cPlayerPositionC ~= 10) && (cPlayerPositionC ~= 11))
                    % do nothing
                else
                    cPlayerPositionR = cPlayerPositionR - 1;
                    iPlayerPositionR = cPlayerPositionR + 1;
                    movementLayer2(iPlayerPositionR,cPlayerPositionC) = 1;
                    movementLayer2(cPlayerPositionR,cPlayerPositionC) = player;
                end
            elseif (keyInput == 'd')
                if (cPlayerPositionC == 11) && ((cPlayerPositionR ~= 7) && (cPlayerPositionR ~= 8) && (cPlayerPositionR ~= 9))
                    % do nothing
                elseif (cPlayerPositionC == 20) && ((cPlayerPositionR == 7) || (cPlayerPositionR == 8) || (cPlayerPositionR == 9))
                    close
                    movementLayer2(cPlayerPositionR, cPlayerPositionC) = 1;
                    break;
                else
                    cPlayerPositionC = cPlayerPositionC + 1;
                    iPlayerPositionC = cPlayerPositionC - 1;
                    movementLayer2(cPlayerPositionR,iPlayerPositionC) = 1;
                    movementLayer2(cPlayerPositionR,cPlayerPositionC) = player;
                end
                % Move the player to the left, blocking movement besides
                % interpass
            elseif keyInput == 'a'
                if (cPlayerPositionC == 9) && ((cPlayerPositionR ~= 7) && (cPlayerPositionR ~= 8) && (cPlayerPositionR ~= 9))
                    % do nothing
                elseif (cPlayerPositionC == 1) && ((cPlayerPositionR == 7) || (cPlayerPositionR == 8) || (cPlayerPositionR == 9))
                    % do nothing
                else
                    cPlayerPositionC = cPlayerPositionC - 1;
                    iPlayerPositionC = cPlayerPositionC + 1;
                    movementLayer2(cPlayerPositionR,iPlayerPositionC) = 1;
                    movementLayer2(cPlayerPositionR,cPlayerPositionC) = player;
                end
            end
        end
    end
    pause(1/framerate-toc)
end










% RIGHT ROOM
right_room = simpleGameEngine('retro_pack.png',16,16,5,[0,0,0]);


% Sprite locations
path_Sprite = 17;
startbridge_Sprite = 5*32 + 16;
bridge_Sprite = 5*32 + 17;
box_Sprite = 14*32 + 15;
blank_sprite= 1;
backgroundLayer3 = blank_sprite * ones(7,9);
movementLayer3 = blank_sprite * ones(7,9);
backgroundLayer3(3,1) = path_Sprite;
backgroundLayer3(4,1)= path_Sprite;
backgroundLayer3(5,1)= path_Sprite;
backgroundLayer3(3,2)= path_Sprite;
backgroundLayer3(4,2)= path_Sprite;
backgroundLayer3(5,2)= path_Sprite;
backgroundLayer3(3,8)= path_Sprite;
backgroundLayer3(4,8)= path_Sprite;
backgroundLayer3(5,8)= path_Sprite;
backgroundLayer3(3,7)= path_Sprite;
backgroundLayer3(4,7)= path_Sprite;
backgroundLayer3(3,9)= path_Sprite;
backgroundLayer3(4,9)= path_Sprite;
backgroundLayer3(5,9)= path_Sprite;
backgroundLayer3(4,3)= bridge_Sprite;
backgroundLayer3(4,4)= bridge_Sprite;
backgroundLayer3(4,5)= bridge_Sprite;
backgroundLayer3(4,6)= bridge_Sprite;
backgroundLayer3(5,7)= path_Sprite;
movementLayer3(4,8)= key;
movementLayer3(4,1) = player;

% Draw initial scene
drawScene(right_room,backgroundLayer3,movementLayer3)

% Player's initial location in right room
cPlayerPositionR = 4;
cPlayerPositionC = 1;

% One of two keys needed to allow player to move on to the next level
hasKey2 = false;

% Start right room mechanics
while 1
    tic

    right_room.my_figure.KeyPressFcn = @(src,event)guidata(src,event.Key);
    right_room.my_figure.KeyReleaseFcn = @(src,event)guidata(src,'0');
    key_down = guidata(right_room.my_figure);
    keyInput = string(key_down);
    % Update scene
    drawScene(right_room,backgroundLayer3,movementLayer3)

    % WASD four-direction movement
    if playerDead == false
        if keyInput ~= '0'
            if (keyInput == 's')
                if (cPlayerPositionR == 4)
                    if (cPlayerPositionC == 1) || (cPlayerPositionC == 2) || (cPlayerPositionC == 7) || (cPlayerPositionC == 8) || (cPlayerPositionC == 9)
                        cPlayerPositionR = cPlayerPositionR + 1;
                        iPlayerPositionR = cPlayerPositionR - 1;
                        movementLayer3(iPlayerPositionR,cPlayerPositionC) = 1;
                        movementLayer3(cPlayerPositionR,cPlayerPositionC) = player;
                    end
                elseif (cPlayerPositionR == 5)
                    % do nothing
                else
                    cPlayerPositionR = cPlayerPositionR + 1;
                    iPlayerPositionR = cPlayerPositionR - 1;
                    movementLayer3(iPlayerPositionR,cPlayerPositionC) = 1;
                    movementLayer3(cPlayerPositionR,cPlayerPositionC) = player;w
                end
            elseif keyInput == 'w'
                if (cPlayerPositionR == 4)
                    if (cPlayerPositionC == 1) || (cPlayerPositionC == 2) || (cPlayerPositionC == 8) || (cPlayerPositionC == 7) || (cPlayerPositionC == 9)
                        cPlayerPositionR = cPlayerPositionR - 1;
                        iPlayerPositionR = cPlayerPositionR + 1;
                        movementLayer3(iPlayerPositionR,cPlayerPositionC) = 1;
                        movementLayer3(cPlayerPositionR,cPlayerPositionC) = player;
                    end
                elseif (cPlayerPositionR == 3)
                    % do nothing
                else
                    cPlayerPositionR = cPlayerPositionR - 1;
                    iPlayerPositionR = cPlayerPositionR + 1;
                    movementLayer3(iPlayerPositionR,cPlayerPositionC) = 1;
                    movementLayer3(cPlayerPositionR,cPlayerPositionC) = player;
                end
            elseif (keyInput == 'd') && (cPlayerPositionC ~= 9)
                if (cPlayerPositionC == 2)
                    if (cPlayerPositionR == 4)
                        cPlayerPositionC = cPlayerPositionC + 1;
                        iPlayerPositionC = cPlayerPositionC - 1;
                        movementLayer3(cPlayerPositionR,iPlayerPositionC) = 1;
                        movementLayer3(cPlayerPositionR,cPlayerPositionC) = player;
                    end
                elseif (cPlayerPositionC == 7)
                    if (cPlayerPositionR == 3) || (cPlayerPositionR == 4) || (cPlayerPosition == 5)
                        cPlayerPositionC = cPlayerPositionC + 1;
                        iPlayerPositionC = cPlayerPositionC - 1;
                        movementLayer3(cPlayerPositionR,iPlayerPositionC) = 1;
                        movementLayer3(cPlayerPositionR,cPlayerPositionC) = player;
                    end
                else
                    cPlayerPositionC = cPlayerPositionC + 1;
                    iPlayerPositionC = cPlayerPositionC - 1;
                    movementLayer3(cPlayerPositionR,iPlayerPositionC) = 1;
                    movementLayer3(cPlayerPositionR,cPlayerPositionC) = player;
                end
                % Move the player to the left, blocking movement besides interpass
            elseif keyInput == 'a'
                if (cPlayerPositionC == 7)
                    if (cPlayerPositionR == 4)
                        cPlayerPositionC = cPlayerPositionC - 1;
                        iPlayerPositionC = cPlayerPositionC + 1;
                        movementLayer3(cPlayerPositionR,iPlayerPositionC) = 1;
                        movementLayer3(cPlayerPositionR,cPlayerPositionC) = player;
                    end
                elseif (cPlayerPositionC == 9)
                    if (cPlayerPositionR == 3) || (cPlayerPositionR == 4) || (cPlayerPositionR == 5)
                        cPlayerPositionC = cPlayerPositionC - 1;
                        iPlayerPositionC = cPlayerPositionC + 1;
                        movementLayer3(cPlayerPositionR,iPlayerPositionC) = 1;
                        movementLayer3(cPlayerPositionR,cPlayerPositionC) = player;
                    end
                else
                    cPlayerPositionC = cPlayerPositionC - 1;
                    iPlayerPositionC = cPlayerPositionC + 1;
                    movementLayer3(cPlayerPositionR,iPlayerPositionC) = 1;
                    movementLayer3(cPlayerPositionR,cPlayerPositionC) = player;
                end
                if (cPlayerPositionR == 4 && cPlayerPositionC == 1)
                    close
                    break;
                end
            end
            if (cPlayerPositionR == 4) && (cPlayerPositionC == 8)
                hasKey2 = true;
            end
        end
    end
    pause(1/framerate-toc)
end









% BACK TO LEVEL 2

% Player's initial location level 2
cPlayerPositionR = 8;
cPlayerPositionC = 20;

% Draw initial scene
drawScene(gameplayLevel2, backgroundLayer2, movementLayer2)

% Start level 2 loop
while 1
    tic

    gameplayLevel2.my_figure.KeyPressFcn = @(src,event)guidata(src,event.Key);
    gameplayLevel2.my_figure.KeyReleaseFcn = @(src,event)guidata(src,'0');
    key_down = guidata(gameplayLevel2.my_figure);
    keyInput = string(key_down);

    % Update scene
    drawScene(gameplayLevel2,backgroundLayer2,movementLayer2)

    % WASD four-direction movement
    if playerDead == false
        if keyInput ~= '0'
            if (keyInput == 's') && (cPlayerPositionR ~= 20)
                if (cPlayerPositionR == 9) && ((cPlayerPositionC ~= 9) && (cPlayerPositionC ~= 10) && (cPlayerPositionC ~= 11))
                    % do nothing
                else
                    cPlayerPositionR = cPlayerPositionR + 1;
                    iPlayerPositionR = cPlayerPositionR - 1;
                    movementLayer2(iPlayerPositionR,cPlayerPositionC) = 1;
                    movementLayer2(cPlayerPositionR,cPlayerPositionC) = player;
                end
            elseif (keyInput == 'w') && (cPlayerPositionR ~= 1)
                if (cPlayerPositionR == 7) && ((cPlayerPositionC ~= 9) && (cPlayerPositionC ~= 10) && (cPlayerPositionC ~= 11))
                    % do nothing
                else
                    cPlayerPositionR = cPlayerPositionR - 1;
                    iPlayerPositionR = cPlayerPositionR + 1;
                    movementLayer2(iPlayerPositionR,cPlayerPositionC) = 1;
                    movementLayer2(cPlayerPositionR,cPlayerPositionC) = player;
                end
            elseif (keyInput == 'd')
                if (cPlayerPositionC == 11) && ((cPlayerPositionR ~= 7) && (cPlayerPositionR ~= 8) && (cPlayerPositionR ~= 9))
                    % do nothing
                else
                    cPlayerPositionC = cPlayerPositionC + 1;
                    iPlayerPositionC = cPlayerPositionC - 1;
                    movementLayer2(cPlayerPositionR,iPlayerPositionC) = 1;
                    movementLayer2(cPlayerPositionR,cPlayerPositionC) = player;
                end
                % Move the player to the left, blocking movement besides
                % interpass
            elseif keyInput == 'a'
                if (cPlayerPositionC == 9) && ((cPlayerPositionR ~= 7) && (cPlayerPositionR ~= 8) && (cPlayerPositionR ~= 9))
                    % do nothing
                elseif (cPlayerPositionC == 1) && ((cPlayerPositionR == 7) || (cPlayerPositionR == 8) || (cPlayerPositionR == 9))
                    close
                    movementLayer2(cPlayerPositionR, cPlayerPositionC) = 1;
                    break
                else
                    cPlayerPositionC = cPlayerPositionC - 1;
                    iPlayerPositionC = cPlayerPositionC + 1;
                    movementLayer2(cPlayerPositionR,iPlayerPositionC) = 1;
                    movementLayer2(cPlayerPositionR,cPlayerPositionC) = player;
                end
            end
        end
    end
    pause(1/framerate-toc)
end








% LEFT ROOM

% Initialize game engine object
left_room = simpleGameEngine('retro_pack.png',16,16,5,[0,0,0]);

% Scene Dungeon
% Initialize sprites with correct png location
entrance_sprite = 3*32 + 12;
S_Sprite = 31*32 + 25;
A_Sprite = 30*32 + 20;
blank_sprite = 1;
player = 28;
trophy_sprite = 28*32 + 25;
collen_sprtie = 29*32 + 30;
zero_sprite = 29*32 + 20;
Percent_sprite = 29*32 + 32;
Dollar_sprite = 28*32 + 20;
Volume_sprite = 28*32 + 23;
setting_sprite = 28*32 + 30;
downstream_sprite = 4*32 + 9;
tree1_sprite = 34;
tree2_sprite = 33;
goodpath_sprite = 5;
alrightpath_sprite = 4;
badpath_sprite = 2;
rampup_sprite = 15*32 + 11;
rampflat_sprite = 15*32 + 12;
rampdown_sprite = 15*32 + 13;
snake_sprite = 8*32 + 29;
coin_sprite= 25*32 + 10;
one_sprite= 29*32 + 21;
seven_sprite= 29*32 + 27;
enemy1 = 6*32 + 32;
bricktrail_sprite = 17;
box_sprite = 14*32 + 15;
flame_sprite = 10*32 +15;
ham_sprite = 28*32 +18;
bridge_sprite= 5*32 + 17;
ickyslimeleft_sprite = 6*32+22;
ickyslimemid_sprite = 6*32+23;
ickyslimeright_sprite = 6*32+24;
key = 23*32 + 17;

% Background layer
movementLayer4 = blank_sprite * ones(7,9);

% Foreground (movement) layer
backgroundLayer4 = blank_sprite * ones(7,9);

% Path
backgroundLayer4(7,:) = bricktrail_sprite;
backgroundLayer4(6,:) = bricktrail_sprite;
backgroundLayer4(5,:) = bricktrail_sprite;
backgroundLayer4(1,:) = blank_sprite;
backgroundLayer4(2,:) = blank_sprite;
backgroundLayer4(3,:) = blank_sprite;
backgroundLayer4(4,:) = blank_sprite;
backgroundLayer4(:,1) = bricktrail_sprite;
backgroundLayer4(:,2) = bricktrail_sprite;
backgroundLayer4(3, 3) = bridge_sprite;
backgroundLayer4(3, 4) = bridge_sprite;
backgroundLayer4(3, 5) = bridge_sprite;
backgroundLayer4(3,6) = bricktrail_sprite;
backgroundLayer4(3,7) = bricktrail_sprite;
backgroundLayer4(3,8) = bricktrail_sprite;
backgroundLayer4(2,6) = bricktrail_sprite;
backgroundLayer4(2,7) = bricktrail_sprite;
backgroundLayer4(2,8) = bricktrail_sprite;
backgroundLayer4(4,6) = ickyslimeleft_sprite;
backgroundLayer4(4,7) = ickyslimemid_sprite;
backgroundLayer4(4,8) = ickyslimeright_sprite;
backgroundLayer4(1,3) = ickyslimeleft_sprite;
backgroundLayer4(1,4) = ickyslimemid_sprite;
backgroundLayer4(1,5) = ickyslimemid_sprite;
backgroundLayer4(1,6) = ickyslimemid_sprite;
backgroundLayer4(1,7) = ickyslimemid_sprite;
backgroundLayer4(1,8) = ickyslimemid_sprite;
backgroundLayer4(1,9) = ickyslimeright_sprite;

% Key
movementLayer4(3,7) = box;

% Initial box position
cBoxPositionR = 3;
cBoxPositionC = 7;

% Flame Ambiance
movementLayer4(5,5) = flame_sprite;
movementLayer4(5,9) = flame_sprite;
movementLayer4(5,8) = flame_sprite;
movementLayer4(5,7) = flame_sprite;
movementLayer4(5,4) = flame_sprite;
movementLayer4(5,3) = flame_sprite;
movementLayer4(5,6) = flame_sprite;
movementLayer4(7,9) = flame_sprite;
movementLayer4(7,8) = flame_sprite;
movementLayer4(7,7) = flame_sprite;
movementLayer4(7,6) = flame_sprite;
movementLayer4(7,5) = flame_sprite;
movementLayer4(7,4) = flame_sprite;
movementLayer4(7,3) = flame_sprite;
movementLayer4(7,2) = flame_sprite;
movementLayer4(7,1) = flame_sprite;
backgroundLayer4(3,1) = plate;
movementLayer4(6,9) = player;
drawScene(left_room,backgroundLayer4,movementLayer4)

% Unlock door condition
unlockDoor = false;

% Draw initial scene
drawScene(left_room,backgroundLayer4,movementLayer4)

% Player's initial location level in left room
cPlayerPositionR = 6;
cPlayerPositionC = 9;
while 1
    tic
    left_room.my_figure.KeyPressFcn = @(src,event)guidata(src,event.Key);
    left_room.my_figure.KeyReleaseFcn = @(src,event)guidata(src,'0');
    key_down = guidata(left_room.my_figure);
    keyInput = string(key_down);
    % Update scene
    drawScene(left_room,backgroundLayer4,movementLayer4)

    % WASD four-direction movement
    if playerDead == false
        if keyInput ~= '0'
            if (keyInput == 's')
                if (cPlayerPositionR == 6) || ((cPlayerPositionR == 2) && (cPlayerPositionC == 7))
                    % do nothing
                elseif (cPlayerPositionR == 3)
                    if (cPlayerPositionC == 1) || (cPlayerPositionC == 2)
                        cPlayerPositionR = cPlayerPositionR + 1;
                        iPlayerPositionR = cPlayerPositionR - 1;
                        movementLayer4(iPlayerPositionR,cPlayerPositionC) = 1;
                        movementLayer4(cPlayerPositionR,cPlayerPositionC) = player;
                    end
                else
                    cPlayerPositionR = cPlayerPositionR + 1;
                    iPlayerPositionR = cPlayerPositionR - 1;
                    movementLayer4(iPlayerPositionR,cPlayerPositionC) = 1;
                    movementLayer4(cPlayerPositionR,cPlayerPositionC) = player;
                end
            elseif (keyInput == 'w') && (cPlayerPositionR ~= 1)
                if (cPlayerPositionR == 6)
                    if (cPlayerPositionC == 1) || (cPlayerPositionC == 2)
                        cPlayerPositionR = cPlayerPositionR - 1;
                        iPlayerPositionR = cPlayerPositionR + 1;
                        movementLayer4(iPlayerPositionR,cPlayerPositionC) = 1;
                        movementLayer4(cPlayerPositionR,cPlayerPositionC) = player;
                    end
                elseif (cPlayerPositionR == 3)
                    if (cPlayerPositionC == 1) || (cPlayerPositionC == 2) || (cPlayerPositionC == 6) || (cPlayerPositionC == 7) || (cPlayerPositionC == 8)
                        cPlayerPositionR = cPlayerPositionR - 1;
                        iPlayerPositionR = cPlayerPositionR + 1;
                        movementLayer4(iPlayerPositionR,cPlayerPositionC) = 1;
                        movementLayer4(cPlayerPositionR,cPlayerPositionC) = player;
                    end
                elseif (cPlayerPositionC == 6) || (cPlayerPositionC == 7) || (cPlayerPositionC == 8)
                    if (cPlayerPositionR == 3)
                        cPlayerPositionR = cPlayerPositionR - 1;
                        iPlayerPositionR = cPlayerPositionR + 1;
                        movementLayer4(iPlayerPositionR,cPlayerPositionC) = 1;
                        movementLayer4(cPlayerPositionR,cPlayerPositionC) = player;
                    end
                else
                    cPlayerPositionR = cPlayerPositionR - 1;
                    iPlayerPositionR = cPlayerPositionR + 1;
                    movementLayer4(iPlayerPositionR,cPlayerPositionC) = 1;
                    movementLayer4(cPlayerPositionR,cPlayerPositionC) = player;
                end

                % Allows player to move the box upward
                if (cPlayerPositionR == cBoxPositionR) && (cPlayerPositionC == cBoxPositionC)
                    cBoxPositionR = cBoxPositionR - 1;
                    iBoxPositionR = cBoxPositionR + 1;
                    movementLayer4(iBoxPositionR, cBoxPositionC) = player;
                    movementLayer4(cBoxPositionR, cBoxPositionC) = box;
                end
            elseif (keyInput == 'd')
                if (cPlayerPositionC == 2)
                    if (cPlayerPositionR == 6) ||(cPlayerPositionR == 3)
                        if ((cPlayerPositionR == 1 && (cPlayerPositionC == 2))) || (((cPlayerPositionC == 8) && (cPlayerPositionR ~= 6)))
                            % do nothing
                        end
                        cPlayerPositionC = cPlayerPositionC + 1;
                        iPlayerPositionC = cPlayerPositionC - 1;
                        movementLayer4(cPlayerPositionR,iPlayerPositionC) = 1;
                        movementLayer4(cPlayerPositionR,cPlayerPositionC) = player;
                    end
                elseif (cPlayerPositionC == 8)
                    if (cPlayerPositionR == 6)
                        cPlayerPositionC = cPlayerPositionC + 1;
                        iPlayerPositionC = cPlayerPositionC - 1;
                        movementLayer4(cPlayerPositionR,iPlayerPositionC) = 1;
                        movementLayer4(cPlayerPositionR,cPlayerPositionC) = player;
                    end
                elseif (cPlayerPositionR == 6 && cPlayerPositionC == 9)
                    close
                    break;
                elseif ((cPlayerPositionR == 3) && (cPlayerPositionC == 6))
                    % do nothing
                else
                    cPlayerPositionC = cPlayerPositionC + 1;
                    iPlayerPositionC = cPlayerPositionC - 1;
                    movementLayer4(cPlayerPositionR,iPlayerPositionC) = 1;
                    movementLayer4(cPlayerPositionR,cPlayerPositionC) = player;
                end
                % Move the player to the left, blocking movement
            elseif (keyInput == 'a') && (cPlayerPositionC ~= 1) && (cBoxPositionC ~= 1)
                if (cPlayerPositionC == 6)
                    if (cPlayerPositionR == 3) || (cPlayerPositionR == 6)
                        cPlayerPositionC = cPlayerPositionC - 1;
                        iPlayerPositionC = cPlayerPositionC + 1;
                        movementLayer4(cPlayerPositionR,iPlayerPositionC) = 1;
                        movementLayer4(cPlayerPositionR,cPlayerPositionC) = player;
                    end
                else
                    cPlayerPositionC = cPlayerPositionC - 1;
                    iPlayerPositionC = cPlayerPositionC + 1;
                    movementLayer4(cPlayerPositionR,iPlayerPositionC) = 1;
                    movementLayer4(cPlayerPositionR,cPlayerPositionC) = player;
                end

                % Allows player to move the box to the left
                if (cPlayerPositionR == cBoxPositionR) && (cPlayerPositionC == cBoxPositionC)
                    cBoxPositionC = cBoxPositionC - 1;
                    iBoxPositionC = cBoxPositionC + 1;
                    movementLayer4(cBoxPositionR, iBoxPositionC) = player;
                    movementLayer4(cBoxPositionR, cBoxPositionC) = box;
                end
            end

            if (cBoxPositionR == 3) && (cBoxPositionC == 1)
                unlockDoor = true;
            end

        end
    end
    pause(1/framerate-toc)
end


% BACK TO LEVEL 2 AGAIN

% Player's initial location level 2
cPlayerPositionR = 8;
cPlayerPositionC = 1;

% Draw initial scene
drawScene(gameplayLevel2, backgroundLayer2, movementLayer2)

% Start level 2 loop
while 1
    tic

    gameplayLevel2.my_figure.KeyPressFcn = @(src,event)guidata(src,event.Key);
    gameplayLevel2.my_figure.KeyReleaseFcn = @(src,event)guidata(src,'0');
    key_down = guidata(gameplayLevel2.my_figure);
    keyInput = string(key_down);

    % Update scene
    drawScene(gameplayLevel2,backgroundLayer2,movementLayer2)

    % WASD four-direction movement
    if playerDead == false
        if keyInput ~= '0'
            if (keyInput == 's')  && (cPlayerPositionR ~= 20)
                if (cPlayerPositionR == 9) && ((cPlayerPositionC ~= 9) && (cPlayerPositionC ~= 10) && (cPlayerPositionC ~= 11))
                    % do nothing
                else
                    cPlayerPositionR = cPlayerPositionR + 1;
                    iPlayerPositionR = cPlayerPositionR - 1;
                    movementLayer2(iPlayerPositionR,cPlayerPositionC) = 1;
                    movementLayer2(cPlayerPositionR,cPlayerPositionC) = player;
                end
            elseif keyInput == 'w'
                if (cPlayerPositionR == 7) && ((cPlayerPositionC ~= 9) && (cPlayerPositionC ~= 10) && (cPlayerPositionC ~= 11))
                    % do nothing
                else
                    cPlayerPositionR = cPlayerPositionR - 1;
                    iPlayerPositionR = cPlayerPositionR + 1;
                    movementLayer2(iPlayerPositionR,cPlayerPositionC) = 1;
                    movementLayer2(cPlayerPositionR,cPlayerPositionC) = player;
                end
            elseif (keyInput == 'd')
                if (cPlayerPositionC == 11) && ((cPlayerPositionR ~= 7) && (cPlayerPositionR ~= 8) && (cPlayerPositionR ~= 9))
                    % do nothing
                else
                    cPlayerPositionC = cPlayerPositionC + 1;
                    iPlayerPositionC = cPlayerPositionC - 1;
                    movementLayer2(cPlayerPositionR,iPlayerPositionC) = 1;
                    movementLayer2(cPlayerPositionR,cPlayerPositionC) = player;
                end
                % Move the player to the left, blocking movement besides
                % interpass
            elseif keyInput == 'a'
                if (cPlayerPositionC == 9) && ((cPlayerPositionR ~= 7) && (cPlayerPositionR ~= 8) && (cPlayerPositionR ~= 9))
                    % do nothing
                else
                    cPlayerPositionC = cPlayerPositionC - 1;
                    iPlayerPositionC = cPlayerPositionC + 1;
                    movementLayer2(cPlayerPositionR,iPlayerPositionC) = 1;
                    movementLayer2(cPlayerPositionR,cPlayerPositionC) = player;
                end
            end

            % Check if player is ready to move on to boss level (must have
            % both keys)
            if ((cPlayerPositionR == 1) && ((cPlayerPositionC == 9) || (cPlayerPositionC == 10) || (cPlayerPositionC == 11))) && ((hasKey2 == true) && (unlockDoor == true))
                close
                break
            end
        end
    end
    pause(1/framerate-toc)
end

% Stop last level's audio
clear sound

% Start final level audo
[y, Fs] = audioread("Teenage Mutant Ninja Turtles - The Arcade Game - Fight - Boss BGM.mp3");
sound(y, Fs);


% FINAL LEVEL
final_level= simpleGameEngine('retro_pack.png', 16,16,5,[45,0,0]);
Blank_sprite= 1;
topFloor_sprite= 20;
topleft_sprite= 32*3 + 21;
topRight_sprite= 32*3 + 22;
leftFloor_sprite= 51;
rightFloor_sprite= 53;
bottomLeft_sprite= 32*4 + 21;
bottomright_sprite= 32*4 + 22;
bottomFloor_sprite= 84;
Bomb_Sprite= 31*32 + 14;
Chain_Sprite= 13*32 + 13;
Coin_Sprite= 25*32 + 10;
coinPile_Sprite= 26*32 + 10;
Throne_Sprite= 8*32 + 1;
Table_Sprite= 7*32 + 9;
crown_Sprite= 22*32 + 18;
bone_Sprite= 15*32 + 1;
Skull_Sprite= 15*32 + 2;
ghost_Sprite= 8*32 + 28;
fireball = 10*32 + 16;
wall_sprite= 13*32 + 1;
window1_sprite= 13*32 +2;
window2_sprite= 13*32+ 3;
gate_Sprite= 13*32 + 4;
window3_Sprite= 12*32+3;
torch_Sprite= 15*32 + 5;
newPath_Sprite= 41;
forcefield = 3*32 + 24;
Character_sprite= 28;
Placement_sprite=26*32 + 25;
bombcover_sprite = 24*32 + 21;
ball_sprite = 5*32 + 21;
Boss1_Display= Blank_sprite * ones(13,13);
Boss2_Display= Blank_sprite * ones(13,13);
drawScene(final_level, Boss1_Display);
drawScene(final_level, Boss2_Display);

% Bombs
Boss2_Display(12,2)= Bomb_Sprite;
Boss2_Display(12,12)= Bomb_Sprite;
Boss1_Display(12,2)= bombcover_sprite;
Boss1_Display(12,12)= bombcover_sprite;

% Main Character
Boss2_Display(12,7)= Character_sprite;

% Tower
bottomTower_Sprite= 23*32 + 16;
topTower_Sprite= 22*32 + 16;

% Path to boss
Boss1_Display(12,7)= newPath_Sprite;
Boss1_Display(11,7)= newPath_Sprite;
Boss1_Display(10,7)= newPath_Sprite;
Boss1_Display(9,7)= newPath_Sprite;
Boss1_Display(8,7)= newPath_Sprite;
Boss1_Display(7,7)= newPath_Sprite;
Boss1_Display(6,7)= newPath_Sprite;
Boss1_Display(5,7)= newPath_Sprite;
Boss1_Display(4,7)= newPath_Sprite;


% Towers
Boss1_Display(4,3)= bottomTower_Sprite;
Boss1_Display(3,3)= topTower_Sprite;
Boss1_Display(4,11)= bottomTower_Sprite;
Boss1_Display(3,11)= topTower_Sprite;
Boss1_Display(1,2)= wall_sprite;
Boss1_Display(2,1)= leftFloor_sprite;
Boss1_Display(1,1)= topleft_sprite;
Boss1_Display(1,13)= topRight_sprite;

% Left floor
Boss1_Display(3,1)= leftFloor_sprite;
Boss1_Display(4,1)= leftFloor_sprite;
Boss1_Display(5,1)= leftFloor_sprite;
Boss1_Display(6,1)= leftFloor_sprite;
Boss1_Display(7,1)= leftFloor_sprite;
Boss1_Display(8,1)= leftFloor_sprite;
Boss1_Display(9,1)= leftFloor_sprite;
Boss1_Display(10,1)= leftFloor_sprite;
Boss1_Display(11,1)= leftFloor_sprite;
Boss1_Display(12,1)= leftFloor_sprite;

% Bottom Floor
Boss1_Display(13,2)= bottomFloor_sprite;
Boss1_Display(13,3)= bottomFloor_sprite;
Boss1_Display(13,4)= bottomFloor_sprite;
Boss1_Display(13,5)= bottomFloor_sprite;
Boss1_Display(13,6)= bottomFloor_sprite;
Boss2_Display(13,7)= gate_Sprite;
Boss1_Display(13,8)= bottomFloor_sprite;
Boss1_Display(13,9)= bottomFloor_sprite;
Boss1_Display(13,10)= bottomFloor_sprite;
Boss1_Display(13,11)= bottomFloor_sprite;
Boss1_Display(13,12)= bottomFloor_sprite;
Boss1_Display(13,1)= bottomLeft_sprite;
Boss1_Display(13,13)= bottomright_sprite;

% Top Floor
Boss1_Display(1,3)= window1_sprite;
Boss1_Display(1,4)= wall_sprite;
Boss1_Display(1,5)= wall_sprite;
Boss1_Display(1,6)= wall_sprite;
Boss1_Display(1,7)= window2_sprite;
Boss1_Display(1,8)= wall_sprite;
Boss1_Display(1,9)= wall_sprite;
Boss1_Display(1,10)= wall_sprite;
Boss1_Display(1,11)= window1_sprite;
Boss1_Display(1,12)= wall_sprite;

% Right Floor
Boss1_Display(2,13)= rightFloor_sprite;
Boss1_Display(3,13)= rightFloor_sprite;
Boss1_Display(4,13)= rightFloor_sprite;
Boss1_Display(5,13)= rightFloor_sprite;
Boss1_Display(6,13)= rightFloor_sprite;
Boss1_Display(7,13)= rightFloor_sprite;
Boss1_Display(8,13)= rightFloor_sprite;
Boss1_Display(9,13)= rightFloor_sprite;
Boss1_Display(10,13)= rightFloor_sprite;
Boss1_Display(11,13)= rightFloor_sprite;
Boss1_Display(12,13)= rightFloor_sprite;

% Throne
Boss1_Display(2,7)= Throne_Sprite;
Boss2_Display(2,7) = ghost_Sprite;

% Bomb Placement
Boss1_Display(5,3)= Placement_sprite;
Boss1_Display(5,11)=Placement_sprite;


% Skulls and Bones
Boss1_Display(10,4)= bone_Sprite;
Boss1_Display(8,10)= Skull_Sprite;

% Coins
Boss1_Display(2,6)= forcefield;
Boss1_Display(3,7)= forcefield;
Boss1_Display(2,8)= forcefield;
drawScene(final_level, Boss1_Display, Boss2_Display)

% Player's initial location final level
cPlayerPositionR = 12;
cPlayerPositionC = 7;

% Boolean bomb condition
hasBomb1 = false;
hasBomb2 = false;

% Initial ball positions
cBall1PositionR = 3;
cBall1PositionC = 3;

cBall2PositionR = 3;
cBall2PositionC = 11;

% Kill player booleans for each ball
killPlayer1 = true;
killPlayer2 = true;

% Boolean value that holds if tower1 and tower2 are still active
tower1Dead = false;
tower2Dead = false;

% If final cut scene has occured or not
finalCutscene = false;

% Dictates ball speed through modulo
moveBall1 = 0;
moveBall2 = 0;

while 1
    tic
    final_level.my_figure.KeyPressFcn = @(src,event)guidata(src,event.Key);
    final_level.my_figure.KeyReleaseFcn = @(src,event)guidata(src,'0');
    key_down = guidata(final_level.my_figure);
    keyInput = string(key_down);
    % Update scene
    drawScene(final_level,Boss1_Display,Boss2_Display)

    % WASD four-direction movement
    if playerDead == false
        if keyInput ~= '0'
            if (keyInput == 's')
                if (cPlayerPositionR == 13)
                    % do nothing
                else
                    cPlayerPositionR = cPlayerPositionR + 1;
                    iPlayerPositionR = cPlayerPositionR - 1;
                    Boss2_Display(iPlayerPositionR,cPlayerPositionC) = 1;
                    Boss2_Display(cPlayerPositionR,cPlayerPositionC) = player;
                end
            elseif keyInput == 'w'
                if (cPlayerPositionR == 1) || ((cPlayerPositionR == 3) && (cPlayerPositionC == 6)) || ((cPlayerPositionR == 4) && (cPlayerPositionC == 7)) || ((cPlayerPositionR == 3) && (cPlayerPositionC == 8))
                    % do nothing
                else
                    cPlayerPositionR = cPlayerPositionR - 1;
                    iPlayerPositionR = cPlayerPositionR + 1;
                    Boss2_Display(iPlayerPositionR,cPlayerPositionC) = 1;
                    Boss2_Display(cPlayerPositionR,cPlayerPositionC) = player;
                end
            elseif (keyInput == 'd')
                if (cPlayerPositionC == 13) || ((cPlayerPositionR == 2) && (cPlayerPositionC == 5)) || ((cPlayerPositionR == 3) && (cPlayerPositionC == 6))
                    % do nothing
                else
                    cPlayerPositionC = cPlayerPositionC + 1;
                    iPlayerPositionC = cPlayerPositionC - 1;
                    Boss2_Display(cPlayerPositionR,iPlayerPositionC) = 1;
                    Boss2_Display(cPlayerPositionR,cPlayerPositionC) = player;
                end
                % Move the player to the left, blocking movements
            elseif keyInput == 'a'
                if (cPlayerPositionC == 1)  || ((cPlayerPositionR == 2) && (cPlayerPositionC == 9)) || ((cPlayerPositionR == 3) && (cPlayerPositionC == 8))
                    % do nothing
                else
                    cPlayerPositionC = cPlayerPositionC - 1;
                    iPlayerPositionC = cPlayerPositionC + 1;
                    Boss2_Display(cPlayerPositionR,iPlayerPositionC) = 1;
                    Boss2_Display(cPlayerPositionR,cPlayerPositionC) = player;
                end
            end
            if cPlayerPositionC == 2 && cPlayerPositionR == 12
                hasBomb1 = true;
            end
            if (cPlayerPositionC == 12 && cPlayerPositionR == 12)
                hasBomb2 = true;
            end
            if (cPlayerPositionR == 5 && cPlayerPositionC == 3 && hasBomb1 == true)
                Boss1_Display(3, 3) = 1;
                Boss1_Display(4,3) = 1;
                tower1Dead = true;
                killPlayer1 = false;
                Boss2_Display(cBall1PositionR, cBall1PositionC) = 1;
                drawScene(final_level,Boss1_Display,Boss2_Display)
            end
            if (cPlayerPositionR == 5 && cPlayerPositionC == 11 && hasBomb2 == true)
                Boss1_Display(3,11) = 1;
                Boss1_Display(4,11) = 1;
                tower2Dead = true;
                killPlayer2 = false;
                Boss2_Display(cBall2PositionR, cBall2PositionC) = 1;
                drawScene(final_level,Boss1_Display,Boss2_Display)
            end

            % Final cut scene killing the ghost from the right tower
            if ((tower1Dead == true) && (tower2Dead == true)) && (finalCutscene == false) && (cPlayerPositionR == 5 && cPlayerPositionC == 11)
                finalCutscene = true;
                pause(1)
                
                Boss1_Display(2,6) = 1;
                Boss1_Display(3,7) = 1;
                Boss1_Display(2,8) = 1;
                drawScene(final_level,Boss1_Display,Boss2_Display)

                pause(0.75)

                cPlayerPositionR = cPlayerPositionR + 1;
                iPlayerPositionR = cPlayerPositionR - 1;
                Boss2_Display(iPlayerPositionR,cPlayerPositionC) = 1;
                Boss2_Display(cPlayerPositionR,cPlayerPositionC) = player;
                drawScene(final_level,Boss1_Display,Boss2_Display)

                for i = 1:1:4
                    pause(0.75)

                    cPlayerPositionC = cPlayerPositionC - 1;
                    iPlayerPositionC = cPlayerPositionC + 1;
                    Boss2_Display(cPlayerPositionR,iPlayerPositionC) = 1;
                    Boss2_Display(cPlayerPositionR,cPlayerPositionC) = player;
                    drawScene(final_level,Boss1_Display,Boss2_Display)
                end

                Boss2_Display(5,7) = fireball;
                cFirePositionR = 5;
                cFirePositionC = 7;
                drawScene(final_level,Boss1_Display,Boss2_Display)

                for i = 1:1:4
                    pause(0.16)

                    cFirePositionR = cFirePositionR - 1;
                    iFirePositionR = cFirePositionR + 1;
                    Boss2_Display(iFirePositionR,cFirePositionC) = 1;
                    Boss2_Display(cFirePositionR,cFirePositionC) = fireball;
                    drawScene(final_level,Boss1_Display,Boss2_Display)
                end

                Boss2_Display(cFirePositionR,cFirePositionC) = 1;
                drawScene(final_level,Boss1_Display,Boss2_Display)
                % Go to victory screen
                close
                pause(1)
                break
            end


            % Final cut scene killing the ghost from the left tower
            if ((tower1Dead == true) && (tower2Dead == true)) && (finalCutscene == false) && (cPlayerPositionR == 5 && cPlayerPositionC == 3)
                finalCutscene = true;
                pause(1)
                
                Boss1_Display(2,6) = 1;
                Boss1_Display(3,7) = 1;
                Boss1_Display(2,8) = 1;
                drawScene(final_level,Boss1_Display,Boss2_Display)

                pause(0.75)

                cPlayerPositionR = cPlayerPositionR + 1;
                iPlayerPositionR = cPlayerPositionR - 1;
                Boss2_Display(iPlayerPositionR,cPlayerPositionC) = 1;
                Boss2_Display(cPlayerPositionR,cPlayerPositionC) = player;
                drawScene(final_level,Boss1_Display,Boss2_Display)

                for i = 1:1:4
                    pause(0.75)

                    cPlayerPositionC = cPlayerPositionC + 1;
                    iPlayerPositionC = cPlayerPositionC - 1;
                    Boss2_Display(cPlayerPositionR,iPlayerPositionC) = 1;
                    Boss2_Display(cPlayerPositionR,cPlayerPositionC) = player;
                    drawScene(final_level,Boss1_Display,Boss2_Display)
                end

                Boss2_Display(5,7) = fireball;
                cFirePositionR = 5;
                cFirePositionC = 7;
                drawScene(final_level,Boss1_Display,Boss2_Display)

                for i = 1:1:4
                    pause(0.16)

                    cFirePositionR = cFirePositionR - 1;
                    iFirePositionR = cFirePositionR + 1;
                    Boss2_Display(iFirePositionR,cFirePositionC) = 1;
                    Boss2_Display(cFirePositionR,cFirePositionC) = fireball;
                    drawScene(final_level,Boss1_Display,Boss2_Display)
                end

                Boss2_Display(cFirePositionR,cFirePositionC) = 1;
                drawScene(final_level,Boss1_Display,Boss2_Display)
                % go to victory screen
                pause(1)
                close
                break
            end


        end
    end

    % Makes random poison balls shoot out from both turrets
    if keyInput == '0'
        % Chooses random direction for balls to shoot out
        ballDirection1 = randi(2);
        ballDirection2 = randi(2);


        % Moves ball 1
        if tower1Dead == false
            if moveBall1 == 0
                if (cBall1PositionR == 13) || (cBall1PositionC == 13)
                    Boss2_Display(cBall1PositionR, cBall1PositionC) = 1;
                    cBall1PositionR = 3;
                    cBall1PositionC = 3;
                elseif (ballDirection1 == 1)
                    if ((cBall1PositionR == 11) && (cBall1PositionC == 12))
                        % do nothing
                    else
                    cBall1PositionR = cBall1PositionR + 1;
                    iBall1PositionR = cBall1PositionR - 1;
                    Boss2_Display(iBall1PositionR,cBall1PositionC) = 1;
                    Boss2_Display(cBall1PositionR, cBall1PositionC) = ball_sprite;
                    end
                else
                    if (cBall1PositionR == 12) && (cBall1PositionC == 11)
                        % do nothing
                    else
                    cBall1PositionC = cBall1PositionC + 1;
                    iBall1PositionC = cBall1PositionC - 1;
                    Boss2_Display(cBall1PositionR,iBall1PositionC) = 1;
                    Boss2_Display(cBall1PositionR, cBall1PositionC) = ball_sprite;
                    end
                end
            end
        end

        % Moves ball 2
        if tower2Dead == false
            if moveBall2 == 0
                if (cBall2PositionR == 13) || (cBall2PositionC == 1)
                    Boss2_Display(cBall2PositionR, cBall2PositionC) = 1;
                    cBall2PositionR = 3;
                    cBall2PositionC = 11;
                elseif (ballDirection2 == 1)
                    if ((cBall2PositionR == 11) && (cBall2PositionC == 2))
                        % do nothing
                    else
                    cBall2PositionR = cBall2PositionR + 1;
                    iBall2PositionR = cBall2PositionR - 1;
                    Boss2_Display(iBall2PositionR,cBall2PositionC) = 1;
                    Boss2_Display(cBall2PositionR, cBall2PositionC) = ball_sprite;
                    end
                else
                    if (cBall2PositionR == 12) && (cBall2PositionC == 3)
                        % do nothing
                    else
                    cBall2PositionC = cBall2PositionC - 1;
                    iBall2PositionC = cBall2PositionC + 1;
                    Boss2_Display(cBall2PositionR,iBall2PositionC) = 1;
                    Boss2_Display(cBall2PositionR, cBall2PositionC) = ball_sprite;
                    end
                end
            end
        end

        % Increments ball movement dictator and calculates it using
        % modulo (only move when moveBall modulo 2 equals 0)
        moveBall1 = moveBall1 + 1;
        moveBall1 = mod(moveBall1, 2);

        moveBall2 = moveBall2 + 1;
        moveBall2 = mod(moveBall2, 2);

        % If player gets hit by ball, game ends
        if (cPlayerPositionR == cBall1PositionR) && (cPlayerPositionC == cBall1PositionC) && (killPlayer1 == true)
            Boss2_Display(cPlayerPositionR,cPlayerPositionC) = 1;
            playerDead = true;
        elseif (cPlayerPositionR == cBall2PositionR) && (cPlayerPositionC == cBall2PositionC) && (killPlayer2 == true)
            Boss2_Display(cPlayerPositionR,cPlayerPositionC) = 1;
            playerDead = true;
        end
    end
    pause(1/framerate-toc)
end




% VICTORY SCREEN

% Stop sound from last level
clear sound

% Start victory screen audio
[y, Fs] = audioread("Stage Win (Super Mario) - QuickSounds.com.mp3");
sound(y, Fs);

% Victory screen
my_end = simpleGameEngine('retro_pack.png',16,16,5,[0,0,0]);
% Loading extra sprites
exclamation_sprite = 25*32 + 20;
smileyface_sprite = 26*32 + 20;
V_sprite= 31*32 + 28;
I_sprite= 30*32 + 28;
C_sprite= 30*32 + 22;
O_sprite= 31*32 + 21;
Y_sprite= 31*32 + 31;
R_Sprite = 31*32 + 24;
T_Sprite = 31*32 + 26;
% Making black background
end_display = (blank_sprite * ones(11,10));
drawScene(my_end,end_display)
% Victory screen sprites
end_display(5,2)= V_sprite;
end_display(5,3)= I_sprite;
end_display(5,4)= C_sprite;
end_display(5,5)= T_Sprite;
end_display(5,6)= O_sprite;
end_display(5,7)= R_Sprite;
end_display(5,8)= Y_sprite;
end_display(5,9)= exclamation_sprite;
end_display(7,5)= smileyface_sprite;
% End screen
drawScene(my_end, end_display)







% FUNCTIONS

% Function to determine the winner, with a 1 representing a player win, a
% -1 representing an enemy win, and a 0 representing a tie
function winner = determineWinner(userAttack, enemyAttack)
if (userAttack == (enemyAttack + 47)) || (userAttack == 51 && enemyAttack == 1)
    winner = 1;
elseif (userAttack == (enemyAttack + 49)) || (userAttack == 49 && enemyAttack == 3)
    winner = -1;
else
    winner = 0;
end
end
