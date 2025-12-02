#!/bin/bash
###################################################################################################
# The purpose of this script is to generate attackable colonies belonging to envoys.

a_user_id=$(psql -d retro-game -U postgres -t -c "select id from users where email = 'envoys@glassow.com';"); 
echo "[INFO] Envoy User ID is: $a_user_id"
a_hw_id=$(psql -d retro-game -U postgres -t -c "select id from bodies where user_id = $a_user_id order by id asc limit 1;") 
echo "[INFO] Envoy HW ID is: $a_hw_id"

#loop until stopped
while true; do
	# Grab the number of planets
  	p_planets=$(psql -d retro-game -U postgres -t -c "select count(*) from bodies where user_id > 8;"); 
  	echo "[INFO] Grabbing Planets: $p_planets"
  
  	# Calculate a 10 day doomsday based on Player Planet Count
  	c_timer=$(( ((4 * 10 * 24 * 60 * 60) / 20 ) / p_planets )); 
  	echo "[INFO] Calculating Sleep Timer: $c_timer"
	w_count=0
  	while [ $w_count -le 40 ]; do
    		w_count=$((w_count+1))
    		echo "[INFO] The Count is now: $w_count"
    		sleep 2
    		# grab a random player's location
    		r_planet=$(psql -d retro-game -U postgres -t -c "SELECT id FROM bodies where kind = 0 and user_id > 8 ORDER BY RANDOM() LIMIT 1;");   
    		echo "[INFO] Grabbing Target Player Planet: $r_planet"

    		p_galaxy=1 #$(psql -d retro-game -U postgres -t -c "SELECT galaxy FROM bodies where id = $r_planet;")
    		p_system=$(psql -d retro-game -U postgres -t -c "SELECT system FROM bodies where id = $r_planet;")
    		p_position=$(psql -d retro-game -U postgres -t -c "SELECT position FROM bodies where id = $r_planet;"); 
    		echo "[INFO] Grabbing Target Player Planet Coords: $p_galaxy : $p_system : $p_position"

    		# pick a spot near it
    		# Generate a random number between -25 and 25
    		offset=$((RANDOM % 20 - 5)); 
    		echo "[INFO] Doing Random Number Things: $offset"

    		# add the offset
    		a_system=$(($p_system + $offset)); 
    		echo "[INFO] Picking System For Envoy Colo: $a_system"
    		echo "[INFO] Envoy System before maths: $a_system"
    		# Check if the result is negative and add 500 if it is
    		if ((a_system < 0)); then
      			sleep 1
      			echo "[WARN] Oh no, system is negative! Ajusting for Doughnut Galaxy..."
      			a_system=$((a_system + 500))
      			sleep 1
    		fi
    		if ((a_system > 500)); then
      			sleep 1
      			echo "[WARN] Oh no, system is too high! Ajusting for Doughnut Galaxy..."
      			a_system=$((a_system - 500))
      			sleep 1
    		fi
    		echo "[INFO] Envoy System: $a_system"

    		# Check if envoy position is open
    		count=$(psql -d retro-game -U postgres -t -c "select count(*) from bodies where galaxy = $p_galaxy and system = $a_system and position = $p_position;"); echo "[INFO] False/True if there is a planet there: $count"
    		
		# if occupied, restart loop
    		if [ $count -gt 0 ]; then
      			echo "[WARN] True, trying again..."
      			continue
    		fi
    
		# grab top players fleet & defense scores
    		t_ships_raw=$(psql -d retro-game -U postgres -t -c "SELECT ROUND(AVG(points)) as average_points FROM (SELECT points FROM fleet_statistics WHERE user_id > 8 ORDER BY at DESC, points DESC LIMIT 5) AS top_5_points;")
    		t_defense_raw=$(psql -d retro-game -U postgres -t -c "SELECT ROUND(AVG(points)) as average_points FROM (SELECT points FROM defense_statistics WHERE user_id > 8 ORDER BY at DESC, points DESC LIMIT 5) AS top_5_points;")
    		t_fleet_raw=$((t_ships_raw + t_defense_raw)); 
    		echo "[INFO] Grabbing Fleet Score:$t_fleet_raw. Then Dividing..."
    		
		# Dividing score by 40
    		#t_fleet=$((t_fleet_raw * 3));     echo "[INFO] New score is: $t_fleet"
		t_fleet=9600000000 

		# Create Planet Names
		#List Names
    		#planet_names=("Aetherion" "Blazorax" "Cygnusara" "Delphionis" "Eryndora" "Fractalus" "Galaxara" "Hypernova-9" "Icarusis" "Jotunheimar" "Krystallon" "Luminara" "Mysterisar" "Nebulix" "Orphelion" "Pyrosara" "Quasarix" "Rhapsodis" "Seraphis" "Titanora" "Utopion" "Vesperis" "Wyrmwood" "Xantheon" "Yggdrasilis" "Zephyrusa" "Olymperia" "Phaetonix" "Quixotara" "Ryujinara" "Solsticea" "Tachyonis" "Umbrawood" "Valkyreon" "Wraithara" "Xenophis" "Yojimbonis" "Zenithara" "Arkonius" "Betelgeusis" "Calypsora" "Dracoheim" "Etherisar" "Fornaxara" "Gravitonix" "Hydrusis" "Ignitara" "Jovionis" "Kryptonora" "Lyrianis")
    		planet_names=("Zentarii" "Quorlox" "Vyxarians" "Thalosians" "Orphelites" "Veltrunari" "Gorgoths" "Zephyrites" "Eclipsari" "Solarnox" "Lunakai" "Neptulans" "Talisarii" "Xenophorians" "Oryxians" "Caelusites" "Veradunari" "Iridesari" "Nephilimara" "Chronoglyphs" "Mysterians" "Galaxarites" "Scorpexi" "Halcyonians" "Celestrians" "Draconix" "Polariana" "Krystallites" "Phobetors" "Andromedans" "Rigelians" "Aetherii" "Plutarns" "Ignisarii" "Helianox" "Utopians" "Silvarii" "Osirians" "Seraphari" "Wraitheon" "Orionites" "Zynthar" "Aquanox" "Solarix" "Lyrianites" "Corvusari" "Wyrmclan" "Eridanites" "Astralari" "Cosmorai")
			# Get the total number of elements in the array
			num_planets=${#planet_names[@]}
			# Generate a random index within the array length
			random_index=$((RANDOM % num_planets))
			# Retrieve the random planet name
			random_planet=${planet_names[$random_index]}
			# Output the randomly selected name
			echo "Random Planet Name: $random_planet"

		# Randomize how much resources are there
    		random_number=$((RANDOM % 31)) # between 0 and 30
    		if [ "$random_number" -ne 0 ]; then
      			# Divide the cargo by the random number and save the result
      			random_base_res=$((t_fleet / random_number));     	echo "[INFO] Base Random Cargo is: $random_base_res"
    		else
      			echo "[INFO] Random number is 0. Cargo will be set to 0"
      			random_base_res=0
    		fi
    		# Determine resource amounts
    		metal=$(echo "scale=0; ($random_base_res * 0.77)/1" | bc); #    		echo "[INFO] Economy Bonus - Metal - $metal"
    		crystal=$(echo "scale=0; ($random_base_res * .44)/1" | bc); #   		echo "[INFO] Economy Bonus - Crystal - $crystal"
    		deut=$(echo "scale=0; ($random_base_res * .44)/1" | bc); #     		echo "[INFO] Economy Bonus - Deut - $deut"
			# Calculate total ships
			total_res=$((metal + crystal + deut));	echo "[INFO] : Total Res: $total_resi"
			hf_percent=$((RANDOM % 4)); 		echo " [INFO] hf percent: $hf_percent out of 4"
			lf_percent=$((RANDOM % 10)); 		echo " [INFO] lf percent: $lf_percent out of 10"
			cs_percent=$((20 + RANDOM % 5)); 	echo " [INFO] cs percent: $cs_percent out of 25"
			sc_percent=$((30 + RANDOM % 15)); 	echo " [INFO] sc percent: $sc_percent out of 45"
			lc_percent=$((35 + RANDOM % 15));	echo " [INFO] lc percent: $lc_percent out of 50"
			hf=$(echo "scale=0; (($total_res * $hf_percent) / 40000)" | bc)
			lf=$(echo "scale=0; (($total_res * $lf_percent) / 50000)" | bc)
			cs=$(echo "scale=0; (($total_res * $cs_percent) / 75000)" | bc)
			sc=$(echo "scale=0; (($total_res * $sc_percent) / 50000)" | bc)
			lc=$(echo "scale=0; (($total_res * $lc_percent) / 250000)" | bc)
			echo "[INFO] Small Cargo: $sc"
			echo "[INFO] Large Cargo: $lc"
			echo "[INFO] Colo Ship: $cs"
			echo "[INFO] Light Fighter: $lf"
			echo "[INFO] Heavy Fighter: $hf"

    	# populate a planet
    		query="insert into bodies (user_id, galaxy, system, position, kind, name, created_at, updated_at, diameter, temperature, type, image, metal, crystal, deuterium, metal_mine_factor, crystal_mine_factor, deuterium_synthesizer_factor, solar_plant_factor, fusion_reactor_factor, solar_satellites_factor, last_jump_at, buildings, units, building_queue, shipyard_queue) values ($a_user_id, $p_galaxy, $a_system, $p_position, 0, '$random_planet', NOW(), NOW(), 10000, 0, 0, 1, $metal, $crystal, $deut, 10, 10, 10, 10, 10, 10, NOW(), '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}', '{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}', '{}', '{}');"
    		psql -d retro-game -U postgres -t -c "$query" || break
			query="update bodies set units[1] = $sc where user_id = $a_user_id and galaxy = $p_galaxy and system = $a_system and position = $p_position;"
			psql -d retro-game -U postgres -t -c "$query" || break
			query="update bodies set units[2] = $lc where user_id = $a_user_id and galaxy = $p_galaxy and system = $a_system and position = $p_position;"
			psql -d retro-game -U postgres -t -c "$query" || break
			query="update bodies set units[3] = $lf where user_id = $a_user_id and galaxy = $p_galaxy and system = $a_system and position = $p_position;"
			psql -d retro-game -U postgres -t -c "$query" || break
			query="update bodies set units[4] = $hf where user_id = $a_user_id and galaxy = $p_galaxy and system = $a_system and position = $p_position;"
			psql -d retro-game -U postgres -t -c "$query" || break
			query="update bodies set units[7] = $cs where user_id = $a_user_id and galaxy = $p_galaxy and system = $a_system and position = $p_position;"
			psql -d retro-game -U postgres -t -c "$query" || break
    	
		# Get Planet ID
    		sleep 1
    		b_id=$(psql -d retro-game -U postgres -t -c "select id from bodies where user_id = 4 order by created_at desc limit 1;"); echo "[INFO] Planet ID: $b_id"
	done
	echo "[INFO] Sleeping $c_timer..."
	sleep $c_timer
done

