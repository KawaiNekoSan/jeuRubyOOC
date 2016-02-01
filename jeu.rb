class Personne
  attr_accessor :nom, :points_de_vie, :en_vie

  def initialize(nom)
    @nom = nom
    @points_de_vie = 100
    @en_vie = true
  end

  def info
    # A faire:
    # - Renvoie le nom et les points de vie si la personne est en vie
    if @en_vie == true
       "#{@nom} a #{@points_de_vie} point(s) de vie"
    # - Renvoie le nom et "vaincu" si la personne a été vaincue
    else
        "#{@nom} est vaincu"
    end
  end

  def attaque(personne)
    # A faire:
    # - Fait subir des dégats à la personne passée en paramètre
    degats_finaux = degats
    personne.subit_attaque(degats_finaux);
    # - Affiche ce qu'il s'est passé
    puts "#{personne.nom} a subi #{degats_finaux} dégats"    
  end

  def subit_attaque(degats_recus)
    # A faire:
    # - Réduit les points de vie en fonction des dégats reçus
    @points_de_vie -= degats_recus
    if @points_de_vie < 0
        puts "#{@nom} a #{@points_de_vie}"
        @points_de_vie = 0
    end    
    # - Affiche ce qu'il s'est passée 
    puts "#{@nom} a maintenant #{@points_de_vie}" 
    # - Détermine si la personne est toujours en_vie ou non
    if @points_de_vie == 0
        @en_vie = false
    end
  end
end

class Joueur < Personne
  attr_accessor :degats_bonus

  def initialize(nom)
    # Par défaut le joueur n'a pas de dégats bonus
    @degats_bonus = 0
    # Appelle le "initialize" de la classe mère (Personne)
    super(nom)
  end

  def degats
    # A faire:
    # - Calculer les dégats 
    # Ici les degats sont au minimum de 20 et maximum 30 et enfin l'ajout du bonus
    degats_finaux =  @degats_bonus + 30 + Random.rand(10)     
    # - Affiche ce qu'il s'est passé
    puts "Le bonus de dégats est de #{degats_bonus}"
    puts "Les dégats sont de #{degats_finaux}"
    return degats_finaux
  end

  def soin
    # A faire:
    # - Gagner de la vie
    # Ici les soins sont au minimum de 40 et maximum 50
    @points_de_vie+=40 + Random.rand(10)
    # - Affiche ce qu'il s'est passé
    puts "#{@nom} a gagné 20 points de vie"
  end

  def ameliorer_degats
    # A faire:
    # - Augmenter les dégats bonus
    # Ici les degats bonus sont au minimum de 20 plus entre 0 et 40
    @degats_bonus = 20 + Random.rand(40)
    # - Affiche ce qu'il s'est passé
    puts "les dégats bonus sont de #{@degats_bonus}"
  end
end

class Ennemi < Personne
  def degats
    # A faire:
    # - Calculer les dégats
    # Les degats des ennemis sont de 10 au minimum et 15 au maximum
    # Les degats des ennemis sont faibles car ils sont trois
    10 + Random.rand(5)
  end
end

class Jeu
  def self.actions_possibles(monde)
    puts "ACTIONS POSSIBLES :"

    puts "0 - Se soigner"
    puts "1 - Améliorer son attaque"

    # On commence à 2 car 0 et 1 sont réservés pour les actions
    # de soin et d'amélioration d'attaque
    i = 2
    monde.ennemis.each do |ennemi|
      puts "#{i} - Attaquer #{ennemi.info}"
      i = i + 1
    end
    puts "99 - Quitter"
  end

  def self.est_fini(joueur, monde)
    # A faire:
    # - Déterminer la condition de fin du jeu
    finEnnemis = true
    monde.ennemis.each do |ennemi|
        if ennemi.en_vie
            finEnnemis = false 
        end
    end
    finJoueur = false
    if joueur.en_vie == false 
        finJoueur = false
    end
    return true if finEnnemis || finJoueur
    else return false
  end
end

class Monde
  attr_accessor :ennemis

  def ennemis_en_vie
    # A faire:
    # - Ne retourner que les ennemis en vie
    ennemis_en_vie_list = []
    @ennemis.each do |ennemi|
      if ennemi.en_vie
        ennemis_en_vie_list << ennemi
      end
    end
    return ennemis_en_vie_list
  end
end

##############

# Initialisation du monde
monde = Monde.new

# Ajout des ennemis
monde.ennemis = [
  Ennemi.new("Balrog"),
  Ennemi.new("Goblin"),
  Ennemi.new("Squelette")
]

# Initialisation du joueur
joueur = Joueur.new("Jean-Michel Paladin")

# Message d'introduction. \n signifie "retour à la ligne"
puts "\n\nAinsi débutent les aventures de #{joueur.nom}\n\n"

# Boucle de jeu principale
100.times do |tour|
  puts "\n------------------ Tour numéro #{tour} ------------------"

  # Affiche les différentes actions possibles
  Jeu.actions_possibles(monde)

  puts "\nQUELLE ACTION FAIRE ?"
  # On range dans la variable "choix" ce que l'utilisateur renseigne
  choix = gets.chomp.to_i

  # En fonction du choix on appelle différentes méthodes sur le joueur
  if choix == 0
    joueur.soin
  elsif choix == 1
    joueur.ameliorer_degats
  elsif choix == 99
    # On quitte la boucle de jeu si on a choisi
    # 99 qui veut dire "quitter"
    break
  else
    # Choix - 2 car nous avons commencé à compter à partir de 2
    # car les choix 0 et 1 étaient réservés pour le soin et
    # l'amélioration d'attaque
    ennemi_a_attaquer = monde.ennemis[choix - 2]
    joueur.attaque(ennemi_a_attaquer)
    joueur.degats_bonus = 0
  end

  puts "\nLES ENNEMIS RIPOSTENT !"
  # Pour tous les ennemis en vie ...
  monde.ennemis_en_vie.each do |ennemi|
    # ... le héro subit une attaque.
    ennemi.attaque(joueur)
  end

  puts "\nEtat du héro: #{joueur.info}\n"

  # Si le jeu est fini, on interompt la boucle
  break if Jeu.est_fini(joueur, monde)
end

puts "\nGame Over!\n"

# A faire:
# - Afficher le résultat de la partie

if joueur.en_vie
  puts "Vous avez gagné !"
else
  puts "Vous avez perdu !"
end




