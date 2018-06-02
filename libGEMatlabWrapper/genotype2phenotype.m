%import libGEjava.*;
function [phenotype_string grammar]=genotype2phenotype(geno, grammar)
%This function does the mapping from genotype to phenotype. It calls
%libGE's jar and gets its work done.
% Inputs:
%   geno: genotype (integer array)
%   grammar: A grammar (java) object, possibly returned from loadGrammar.m
%Output:
%   pheno: phenotype (string)


%-----------------------------------------------------------------
%geno was double type array so I converted it into integer type
if(~isjava(grammar))
    fprintf(1, 'grammar is not a valid java object');
    return;
end
geno = uint32(geno);
%disp(geno);
%To check geno & grammar data type
disp(class(geno));
disp(class(grammar));

clear JAVA;
libGEpath=strcat(fileparts(which('loadGrammar.m')), '/libGEjar/GrammaticOptimization.jar');
% javarmpath(libGEpath);
javaaddpath(libGEpath);
%javaclasspath;

% Just to display the list of all the methods in GEGrammar
%methodsview libGEjava.GEGrammar;


grammar.setGenotype(geno, length(geno));

try
    grammar.genotype2phenotype('true');
    %javaMethod('genotype2phenotype', GEGrammar, 1);
catch E
    switch E.identifier
        case 'MATLAB:java.lang.Exception'
            fprintf('Caught this: In Main: %s\n',getReport(E));
        case 'MATLAB:java.lang.NoClassDefFoundError'
            %E.printStackTrace();
            fprintf('Caught this: printStackTrace: %s\n',getReport(E));
    end
end

if(grammar.getPhenotype().getValid()==1)
    fprintf("\nThe above phenotype is valid\n");
else 
    fprintf("\nThe above phenotype is not valid\n");
end
%pheno.string=grammar.phenotypetoString();
%pheno.phenotype=grammar.getPhenotype();
%pheno.
%We can probably set the penotype to grammar object and return it as
%grammar has both genotype, phenotype and the string representation of the
%phenotype.
pheno=javaObject('libGEjava.GEGrammar', grammar);
phenotype_string=grammar.getPhenotypeString();
disp(phenotype_string);
end