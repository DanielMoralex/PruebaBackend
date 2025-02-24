from flask import Flask, request, jsonify
import pymzn

pymzn.config['minizinc'] = 'minizinc' 

app = Flask(__name__)

@app.route('/solve', methods=['POST'])
def solve():
    try:
        # Recibir datos JSON de la app Android
        data = request.get_json()
        
        # Modelo de MiniZinc (puedes cambiarlo según tu necesidad)
        model = """
        var 0..100: x;
        var 0..100: y;
        constraint x + y == {sum};
        solve maximize x;
        output [ "x = " ++ show(x) ++ ", y = " ++ show(y) ];
        """.format(sum=data.get("sum", 10))  # Suma que recibimos del cliente
        
        # Guardar el modelo en un archivo temporal
        with open("model.mzn", "w") as f:
            f.write(model)
        
        # Resolver usando pymzn
        result = pymzn.minizinc("model.mzn")

        solution_list = [str(sol) for sol in result]
        
        # Devolver la solución en formato JSON
        return jsonify({"solution": solution_list})

    except Exception as e:
        return jsonify({"error": str(e)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
