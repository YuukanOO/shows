## Architecture du répertoire

À la base, une gem n'est rien de plus qu'un répertoire contenant un fichier .gemspec.

Commençons donc par créer l'architecture de notre gem en créant les répertoires et fichiers suivants :

- bin/
- lib/
    - shows/
        - version.rb
- shows.gemspec

## Le fichier .gemspec

Voici ce que nous avons pour notre gem :

    # -*- encoding: utf-8 -*-
    $:.push File.expand_path("../lib", __FILE__)

    require 'shows/version'

    Gem::Specification.new do |s|
        s.name = "shows"
        s.version = Shows::VERSION
        s.authors = ["Julien Leicher"]
        s.email = ["jleicher@gmail.com"]
        s.homepage = ""
        s.summary = "A cli application to follow TV show releases"
        s.description = "A cli application to follow TV show releases!"

        s.rubyforge_project = "shows"

        s.files = Dir['lib/**/*', 'bin/**/*']
    end

La première ligne permet ici de compléter le PATH de ruby pour inclure notre répertoire `lib/`.

Le fichier `.gemspec` regroupe l'ensemble des informations concernant votre gem. La plupart des informations vous sembleront claires mais intéressons-nous à la dernière ligne :

    s.files = Dir['lib/**/*', 'bin/**/*']

Ici nous avons précisé les répertoires contenant du code source pour notre gem à l'aide d'un tableau. Cependant, si votre projet fait partie d'un dépôt git, on voit souvent ce genre de chose :

    s.files = `git ls-files`.split("\n")

Ce qui permet de déléguer le listage du contenu à la commande git. C'est à vous de voir.

## shows/version.rb

Vous avez sans doute remarqué la présence de `require 'shows/version` dans le `.gemspec`, regardons le contenu de ce fichier :

    module Shows

        VERSION = 1.0.0

    end

Simple, n'est-ce pas ? Un simple module Ruby avec une constante.

## Construire & installer votre gem

### Basique

C'est bien sympa mais ce serait cool de pouvoir construire et installer notre gem ! Rien de plus simple, à la racine de votre gem, lancer `gem build shows.gemspec` pour construire votre gem et `gem install shows-1.0.0.gem` pour l'installer, vous devriez obtenir ceci à la suite de ces deux commandes :

    WARNING:  licenses is empty
    WARNING:  no homepage specified
        Successfully built RubyGem
        Name: shows
        Version: 1.0.0
        File: shows-1.0.0.gem

    Successfully installed shows-1.0.0
        Parsing documentation for shows-1.0.0
        Installing ri documentation for shows-1.0.0
        Done installing documentation for shows after 0 seconds
        1 gem installed

### Avec Rake

Maintenant, on aimerait bien faire en sorte que ce soit plus rapide, car taper ces 2 commandes à longueur de journée risque de devenir fatiguant. Nous allons donc utiliser Rake pour nous faciliter la vie.

Créer un fichier `Rakefile` à la racine :

    require "bundler/gem_tasks"

Ces tâches sont tellement basiques que bundler nous les fournit déjà (il vous sera nécessaire d'installer les gems `rake` et `bundler` si vous souhaitez utiliser cette technique).

Désormais, pour construire et installer votre gem, un simple `rake install` et le tour est joué !

## Ajouter un exécutable

Dans le répertoire `bin/`, créer un fichier `shows` et copier le contenu suivant :

    #!/usr/bin/env ruby

    require 'shows/version'

    puts("Hello from shows #{Shows::VERSION}!")

De manière à ce qu'il soit disponible après l'installation de notre gem, il faut le préciser dans le fichier .gemspec, ajouter donc la ligne suivante :

    s.executables = ['shows']

Après avoir reconstruit et réinstallé la gem, vous devriez pouvoir lancer la commande `shows` et voir ce magnifique message :

    Hello from shows 1.0.0!

Si ce n'est pas le cas, vérifier votre PATH.

## Un peu de structure

Il arrive un moment où vous voulez séparer votre gem dans plusieurs fichiers mais être capable, avec un simple `require 'shows'` d'accéder aux différentes fonctions.

Heureusement, c'est très simple à faire et nous allons le voir en séparant notre simple message "Hello".

Commencer par créer le fichier `lib/shows/cli.rb` et remplisser le comme ceci :

    require 'shows/version'

    module Shows

        def self.execute
            puts("Hello from shows #{Shows::VERSION}!")
        end

    end

On crée une fonction toute simple dans notre module et c'est cette fonction que nous souhaitons appeler depuis notre exécutable.

Dans notre fichier `bin/shows`, on modifie notre code :

    #!/usr/bin/env ruby

    require 'shows/cli'

    Shows::execute

Vous comprenez rapidement que si on ajoute d'autres fichiers, on va vite se perdre avec les `require`. De manière à simplifier tout ça, créer un fichier `lib/shows.rb` avec le contenu qui suit :

    require 'shows/cli'

et n'oublier pas de modifier le fichier `bin/shows` :

    #!/usr/bin/env ruby

    require 'shows'

    Shows::execute

Et voilà ! Une gem bien organisée, une ! En règle générale, on préférera éviter d'inclure de base la partie cli dans `lib/shows.rb`, le but étant d'avoir tout d'abord une librairie utilisable à son tour par d'autres librairies.