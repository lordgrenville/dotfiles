# create venv, silently update pip
function create_env
    python3 -m venv temp_env/; source temp_env/bin/activate.fish
end

# function
#     create_env python3 -m venv temp_env/; source temp_env/bin/activate; echo 'Updating pip...'; $(which python3.9) -m pip install --upgrade pip 1>/dev/null
# end

