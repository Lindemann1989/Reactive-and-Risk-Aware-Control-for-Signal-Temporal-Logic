% TOOLBOX DESCRIPTION AT BOTTOM OF THE SCRIPT

% Change reactivity elements in:
% check_feasible_transition
% check_physical_transition
% check_reactive_transition
% check_reactivity
% dfs1_uncontrollable
% dfs2_uncontrollable
% NDFS_uncontrollable
% NDFS_uncontrollable_replan
% pi_
% testing

clc; clear all; close all;
p0 = {'-p2','-p3','-p4','-p5','-p6'}; % Initial State of the system 


global Parameter
Parameter.ind = 4; % indicates which parameter is uncontrollable (used to identify uncontrollable parameters within the code)
Parameter.add_time_reset = 0.0001; %Is added after each transition to the current clock values (this is a technical trick for the region automaton)
 
tic

% Zeta Determines frequency by which uncontrollable events may occur, see Assumption 2
%zeta = 1; % Setting 1
zeta = 5; % Setting 2

% Define other clock constants
g = 1; % minimum transition time
eve = 5; % end point of time interval for reaching R1
eve_re =3; % end point of time interval for reaching R2
eve_past = 1; % end point of time interval for past evenutally operator
cl = [11,2,3,4,5]; %% 11 indicates uncontrollable clock
clv = [zeta,eve_re,eve_past,eve,g];

%i1 = Identity_continuous('p1'); % not used here
i2 = Identity_continuous('p2'); % region R1 (on the right)
i3 = Identity_continuous('p3'); % region O1
i4 = Identity_continuous('p4'); % region O2
i5 = Identity_uncontrollable('p5',[cl(1),clv(1)]); % reactive element
i6 = Identity_continuous('p6'); % region R2 (on the left for reactive element)


% Compositionally Construct Timed Signal Transducer
% io_comp_ST denotes input-output composition
% product_ST denotes parallel product

% Reachability of R1
e1 = Eventually([cl(4),clv(4)]);
t1.ST = io_comp_ST(i2,e1); 
% Obstacles O1 and O2
n1_  = Negation();
t1_.ST = io_comp_ST(i3,n1_);
n2_  = Negation();
t2_.ST = io_comp_ST(i4,n2_);
p1_.ST = product_ST(t1_,t2_);
c1_ = Conjunction();
t3_.ST = io_comp_ST(p1_,c1_);
% Reactive Element 
% Uncontrollable
e1p_ = Eventually_past([cl(3),clv(3)]);
t4_.ST = io_comp_ST(i5,e1p_);
n3_  = Negation();
t5_.ST = io_comp_ST(t4_,n3_);
% Reachability R2
e1_ = Eventually([cl(2),clv(2)]);
t6_.ST = io_comp_ST(i6,e1_);

% product 'Uncontrollable' and 'Reachability R2'
p2_.ST = product_ST(t5_,t6_);
d1_  = Disjunction();
t7_.ST = io_comp_ST(p2_,d1_); % reactive element
% product 'Obstacles O1 and O2' and 'Reactive Element'
p3_.ST = product_ST(t3_,t7_);
c2_ = Conjunction();
t8_.ST = io_comp_ST(p3_,c2_);
a1_ = Always_inf();
t9_.ST = io_comp_ST(t8_,a1_);
% product 'Obstacles O1 and O2' and 'Reactive Element' and 'Reachability of
% R1'
c1__ = Conjunction();
p1__.ST = product_ST(t1,t9_);
t1__.ST = io_comp_ST(p1__,c1__);


final.ST = t1__.ST; 

% Product Automaton
final.ST = intersection(final.ST,g);
disp(['Construction of timed signal transducer took ' num2str(toc) ' seconds']);

% Region Automaton
tic
RA = region(final.ST,p0,zeta);
disp(['Construction of region automaton took ' num2str(toc) ' seconds']);

% Game-based approach
tic
W = game(RA);
disp(['Timed automata game took ' num2str(toc) ' seconds']);

% Save data
%save('all_','-v7.3')

% Load data
%load('all_')

% Nested Depth First Search 
% Initial Plan
max1 = 15;
max2 = 5;
variant = 2; %1: pre-order; 2: depth
tic
path_in = NDFS_uncontrollable(RA,max1,max2,variant,W,1); % path_in contains states and state labels of the planned initial path, timings are then calculated as in [39] or [13]
disp(['Initial graph search took ' num2str(toc) ' seconds']);

% Replan
state = 'r11'; % Select one that is non-zeno: In this state an uncontrollable proposition is simulated
tic
path_replanned = NDFS_uncontrollable_replan(RA,max1,max2,variant,W,state,1); % path_replanned contains states and state labels of the replanned path, starting from 'state', timings are then calculated as in [39] or [13]
disp(['Replanning graph search took ' num2str(toc) ' seconds']);



% 'operation 1, 2, 3, and 4' are contained in 'product_ST' and delete states
% and transitions that are spatially/physically not possible (operation 5
% and 6 are taken care of more easily)

% ADD DESCRIPTION OF CHECK_PHYSICAL_TRANSITION AND
% CHECK_REACTIVE_TRANSITION AND CHECK_REACTIVITY 

% 'check_labels' is used in 'io_comp_ST' and checks if the input label fits
% the output label

% 'check_input_labels' is used in 'region' to check initial state p0 with
% initial automata state

% 'initial_clock_zones', 'find_successors', and 'calc_reset' are used in 
% 'region' to play with clock zones

% 'check_guard' and 'check_invariant' are used in 'region' to check
% feasibility of transitions

% 'check_ambiguous_states' is used in 'region' to avoid adding states that
% already exists (this function is a computational bottleneck)

% 'check_feasible_transitions' is used in 'dfs1' and 'dfs2' (is this
% function really needed?)

% TODO LIST : Speed up check_ambiguity, Always_inf not entirely correct,
% Cycle search

% IMPORTANT: Don't forget to adapt the function operation1 and operation2 and operation 3 for the purpose of the task
% at hand! Also adapt p0. 