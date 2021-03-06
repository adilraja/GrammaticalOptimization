function [pop, params]=ge_evalPopMT(pop, params, train_y)
    popsize=length(pop);
    j=0;
    for(i=1:popsize)
        if(~ge_isKeyofGenotypeCache(pop(i), params.genotypeCache))
            %Do nothing if the individual is not in the cache
            if(pop(i).valid==1)
                pop(i)=feval(params.fitnessFunction, pop(i), params, train_y(:,i));
            elseif(pop(i).valid==0)
                pop(i).fitness=params.maxBadFitness;
                if(params.data.test)
                    pop(i).testFitness=params.maxBadFitness;
                end
            end
            pop(i).isEvaluated=1;
            params=ge_addIndtoGenotypeCache(pop(i), params);
        else%if the individual is present in the cache
            temp_key=sprintf('%d', pop(i).genome);
            temp_ind=params.genotypeCache(temp_key);
            pop(i).fitness=temp_ind.fitness;
            pop(i).testFitness=temp_ind.fitness;
            pop(i).valid=temp_ind.valid;
        end
        
        if(pop(i).valid==1)
            j=j+1;
        end
    end
    numValid=j;
%     disp('Returning from evalPop');
end