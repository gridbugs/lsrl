define [
    'system/description'
    'assets/assets'
    'system/cell'
    'system/knowledge'
    'system/character'
    'system/weapon'
    'asset_system'
    'types'
    'util'
], (Description, Assets, Cell, Knowledge, Character, Weapon, AssetSystem, Types, Util) ->
    AssetSystem.makeAsset 'Describer', {
        displayName: 'English'
        init: ->
            style = {}
            for k, v of Description.StyleFunctions
                style[k] = v

            return style

        install: ->
            style = @init()

            class Verb
                (@string, @thirdPersonSingularEnding = 's', @thirdPersonSingularReplacement) ->
                    if not @thirdPersonSingularReplacement?
                        @thirdPersonSingularReplacement = @string + @thirdPersonSingularEnding
                makeThirdPersonSingular: ->
                    @string = @thirdPersonSingularReplacement
                toString: ->
                    return @string

            verb = (subject, verb) ->
                desc = subject.describe()
                if typeof verb == 'string'
                    verb = new Verb(verb, 's')
                if desc.thirdPersonSingular
                    verb.makeThirdPersonSingular()
                return new Description([subject.describe(), ' ', verb.toString()])

            Cell::describe = ->
                if @character? and @character.describe?
                    return @character.describe()
                else if @feature.type != Types.Feature.Null and @feature.describe?
                    return @feature.describe()
                else
                    return @ground.describe()

            Knowledge.KnowledgeCell::describe = ->
                if @known
                    return @gameCell.describe()
                else
                    return new Description(['unknown'])


            Assets.Ground.Grass::describe = ->
                return new Description(['grass covered ground'])

            Assets.Ground.Stone::describe = ->
                return new Description(['stone floor'])

            Assets.Ground.Dirt::describe = ->
                return new Description(['bare patch of dirt'])

            Assets.Ground.Moss::describe = ->
                return new Description(['moss covered floor'])

            Assets.Feature.Tree::describe = ->
                return new Description(['tree'])

            Assets.Feature.Water::describe = ->
                return new Description(['water'])

            Assets.Feature.Wall::describe = ->
                return new Description(['stone wall'])

            Assets.Feature.StoneDownwardStairs::describe = ->
                return new Description(['stone staircase leading downwards'])

            Character::getPossessive = ->
                return 'its'

            Character::needsArticle = ->
                return true

            Assets.Character.Spider::describe = ->
                return new Description(['spider'])

            Assets.Character.Human::describe = ->
                return new Description(['human'])

            Assets.ContinuousEffect.Poisoned::describe = ->
                return new Description([style.purple(["poisoned (#{@remainingTime})"])])

            Weapon::needsArticle = ->
                return true

            Assets.Weapon.BareHands::getAttackVerb = ->
                return Util.getRandomElement([
                    new Verb('punch', 'es'),
                    'kick'
                ])

            Assets.Weapon.BareHands::includeWeaponName = ->
                return false

            Assets.Weapon.BareHands::includeWeaponName = ->
                return false

            Assets.Weapon.SpiderFangs::getAttackVerb = ->
                return 'bite'

            Assets.Weapon.SpiderFangs::includeWeaponName = ->
                return true

            Assets.Weapon.SpiderFangs::describe = ->
                return 'fangs'

            getCharacterActionDescription = (character, v) ->
                desc = new Description([])
                if character.needsArticle()
                    desc.append('the ')
                desc.append(verb(character, v))
                return desc

            Assets.Action.BumpIntoWall::describe = ->
                return new Description([verb(@character, 'bump'), ' into the ', @object.describe(), '.'])
                    .capitaliseFirstLetter()

            Assets.Action.AttackHit::describe = ->
                desc = new Description([])
                if @character.needsArticle()
                    desc.append('the ')
                desc.append(new Description([verb(@character, @character.weapon.getAttackVerb()), ' ']))
                if @targetCharacter.needsArticle()
                    desc.append('the ')
                desc.append(new Description([@targetCharacter.describe()]))
                if @character.weapon.includeWeaponName()
                    desc.append(' with ')
                    if @character.weapon.needsArticle()
                        desc.append(new Description([@character.getPossessive(), ' ']))
                    desc.append(@character.weapon.describe())
                desc.append('.')
                desc.capitaliseFirstLetter()

                return desc

            Assets.Action.Die::describe = ->
                desc = getCharacterActionDescription(@character, 'die')
                desc.append('.')
                desc.capitaliseFirstLetter()
                return desc

            Assets.Action.GetStuckInWeb::describe = ->
                desc = getCharacterActionDescription(@character, 'get')
                desc.append(' stuck in the web.')
                desc.capitaliseFirstLetter()
                desc = style.red([desc])
                return desc

            Assets.Action.StruggleInWeb::describe = ->
                desc = getCharacterActionDescription(@character, 'struggle')
                desc.append(' in the web.')
                desc.capitaliseFirstLetter()
                return desc

            Assets.Action.BreakWeb::describe = ->
                desc = getCharacterActionDescription(@character, 'break')
                desc.append(' free from the web.')
                desc.capitaliseFirstLetter()
                desc = style.green([desc])
                return desc

            Assets.Action.BecomePoisoned::describe = ->
                desc = getCharacterActionDescription(@character, 'become')
                desc.append(' poisoned.')
                desc.capitaliseFirstLetter()
                desc = style.purple([desc])
                return desc

            Assets.Action.Restore::describe = ->
                desc = getCharacterActionDescription(@character, new Verb('are', void, 'is'))
                desc.append(' resurrected.')
                desc.capitaliseFirstLetter()
                desc = style.yellow([desc])
                return desc

            Assets.Action.Wait::describe = ->
                desc = getCharacterActionDescription(@character, 'stand')
                desc.append(' still for a while.')
                desc.capitaliseFirstLetter()
                return desc

        installPlayerCharacter: (pc) ->
            pc.describe = ->
                return new Description.PluralDescription(['you'])

            pc.getPossessive = ->
                return 'your'

            pc.needsArticle = ->
                return false
    }