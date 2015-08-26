module WebStorage where

import Prelude

import Control.Monad.Eff.Console
import Control.Monad.Eff.Console.Unsafe
import Control.Bind

import Control.Monad.Eff
import Data.Nullable
import Data.Foreign
import Data.Foreign.Index
import Data.Either.Unsafe (fromRight)

import DOM
import DOM.HTML

-- | WebStorage effect
foreign import data WEBSTORAGE :: !

newtype Key   = Key String
newtype Value = Value String

-- | Effect type for Storage access
type EffWebStorage eff = Eff (webStorage :: WEBSTORAGE | eff)

-- | Phantom types of various Storages
data Local
data Session

-- | Storage object
type Storage a
  = { clear      :: forall eff. EffWebStorage eff Unit
    , getItem    :: forall eff. Key -> EffWebStorage eff (Nullable Value)
    , key        :: forall eff. Int -> EffWebStorage eff (Nullable Key)
    , length     :: forall eff. EffWebStorage eff Int
    , removeItem :: forall eff. Key -> EffWebStorage eff Unit
    , setItem    :: forall eff. Key -> Value -> EffWebStorage eff Unit
    }

foreign import toStorage :: forall a storageType. Foreign -> Storage storageType

getLocalStorage :: forall eff. Eff (dom :: DOM | eff) (Storage Local)
getLocalStorage = toStorage <<< fromRight <$> getGlobalProperty "localStorage"

getSessionStorage :: forall eff. Eff (dom :: DOM | eff) (Storage Session)
getSessionStorage = toStorage <<< fromRight <$> getGlobalProperty "sessionStorage"

getGlobalProperty :: forall eff a. String -> Eff (dom :: DOM | eff) (F Foreign)
getGlobalProperty key = prop key <<< toForeign <$> window

test = do
  storage <- getLocalStorage

  print =<< storage.length
  storage.setItem (Key "foo") (Value "bar")
  logAny =<< storage.getItem (Key "foo")
  print =<< storage.length
  logAny =<< storage.getItem (Key "foo")
