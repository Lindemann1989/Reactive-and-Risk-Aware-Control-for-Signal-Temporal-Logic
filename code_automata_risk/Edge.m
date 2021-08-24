classdef Edge
   properties
       s
       ss
       g
       R
   end
   methods
       % Constructor
       function obj = Edge(s_,ss_,g_,R_)
           if nargin > 0
               obj.s = s_;
               obj.ss = ss_;
               obj.g = g_;
               obj.R = R_;
           end
       end
       function r = lambda(obj,n)
          r = [obj.Value] * n;
       end
   end
end