void main() 
{
  String variable1='Gregorio';
  String variable2='';
  int numero1=0;
  
  print('Esto es un numero $variable1 $variable2 $numero1');
  
  
  // Listas-index  0,1,2,3,4,5   
  List    numeros=["1",2,3,4,5,6]; //Esto es una 
  //Int
  //Dynamic //
  
 // lista Dinamica
  
  
  print(numeros);
  numeros.add(7);
  print(numeros);
  
  numeros.add("Maria");
  
  print(numeros);
  
  print('**********Tamaño de la lista*************');
  print(numeros.length);
  
  //camelCase
  //No se usa camelCase en clases y archivos,
  
  // class personaTrabajo{
  
  //}
  
  
  
  
  final masNumeros= List.generate(100,(int index)=> index);
  print(masNumeros);
  
  
  print("**********Lista String**************");
  List<String> estudiantes=[
    
    'Ana',
    'Carlos',
    'Lula',
    'Maria'
  ];
  

  
  
  
  print(estudiantes);
  estudiantes.add("Juan");
  print(estudiantes);
  
  estudiantes.remove('Ana');
    
    print('remover nombre');
    
  print(estudiantes);
  
  
  print('*********INDICE************');
  print(estudiantes.length);
 // print(estudiantes[5]);
  
 


  
  
}// fin del main
